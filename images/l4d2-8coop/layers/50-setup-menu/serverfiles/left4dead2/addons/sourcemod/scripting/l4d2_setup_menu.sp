#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "0.2.0"

ConVar g_hAutoOpen;
ConVar g_hDelay;
ConVar g_hOncePerConnect;
ConVar g_hVoteTime;

// Survives chapter changelevel reconnects for the life of the plugin/server.
StringMap g_ShownAuthIds;

public Plugin myinfo =
{
	name = "L4D2 Setup Menu",
	author = "joshhsoj1902",
	description = "Auto-open a setup launcher for campaign, mode, difficulty, and character",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	g_ShownAuthIds = new StringMap();

	g_hAutoOpen = CreateConVar("l4d2_setup_menu_auto", "1", "Open the setup menu automatically when a human joins (1/0)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_hDelay = CreateConVar("l4d2_setup_menu_delay", "8.0", "Seconds after join before the setup menu opens", FCVAR_NOTIFY, true, 1.0, true, 60.0);
	g_hOncePerConnect = CreateConVar("l4d2_setup_menu_once", "1", "Only auto-open once per SteamID per server session (survives chapter reconnects) (1/0)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_hVoteTime = CreateConVar("l4d2_setup_menu_vote_time", "15", "Seconds for difficulty votes", FCVAR_NOTIFY, true, 5.0, true, 60.0);

	RegConsoleCmd("sm_setup", Command_Setup, "Open the L4D2 setup menu");
	RegConsoleCmd("sm_menu", Command_Setup, "Open the L4D2 setup menu");

	AutoExecConfig(true, "l4d2_setup_menu");
}

public void OnPluginEnd()
{
	delete g_ShownAuthIds;
}

public void OnConfigsExecuted()
{
	// MapChanger defaults to flags "kp" / "k", which blocks normal friends.
	ConVar accessDef = FindConVar("l4d_mapchanger_default_voteaccess");
	if (accessDef != null)
	{
		accessDef.SetString("");
	}

	ConVar accessCustom = FindConVar("l4d_mapchanger_custom_voteaccess");
	if (accessCustom != null)
	{
		accessCustom.SetString("");
	}
}

bool GetClientAuthKey(int client, char[] key, int maxlen)
{
	if (!GetClientAuthId(client, AuthId_Steam2, key, maxlen) || key[0] == '\0')
	{
		return false;
	}
	return true;
}

bool HasShownForClient(int client)
{
	char key[64];
	if (!GetClientAuthKey(client, key, sizeof(key)))
	{
		return false;
	}

	bool shown;
	return g_ShownAuthIds.GetValue(key, shown) && shown;
}

void MarkShownForClient(int client)
{
	char key[64];
	if (!GetClientAuthKey(client, key, sizeof(key)))
	{
		return;
	}
	g_ShownAuthIds.SetValue(key, true);
}

public void OnClientPutInServer(int client)
{
	if (!g_hAutoOpen.BoolValue)
	{
		return;
	}

	if (client <= 0 || IsFakeClient(client))
	{
		return;
	}

	if (g_hOncePerConnect.BoolValue && HasShownForClient(client))
	{
		return;
	}

	CreateTimer(g_hDelay.FloatValue, Timer_AutoOpen, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_AutoOpen(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0 || !IsClientInGame(client) || IsFakeClient(client))
	{
		return Plugin_Stop;
	}

	if (g_hOncePerConnect.BoolValue && HasShownForClient(client))
	{
		return Plugin_Stop;
	}

	// Auth can lag slightly after PutInServer; wait until SteamID is available.
	if (g_hOncePerConnect.BoolValue)
	{
		char key[64];
		if (!GetClientAuthKey(client, key, sizeof(key)))
		{
			CreateTimer(1.0, Timer_AutoOpen, userid, TIMER_FLAG_NO_MAPCHANGE);
			return Plugin_Stop;
		}
	}

	MarkShownForClient(client);
	ShowSetupMenu(client);
	return Plugin_Stop;
}

public Action Command_Setup(int client, int args)
{
	if (client <= 0 || !IsClientInGame(client))
	{
		return Plugin_Handled;
	}

	ShowSetupMenu(client);
	return Plugin_Handled;
}

void ShowSetupMenu(int client)
{
	Menu menu = new Menu(MenuHandler_Setup);
	menu.SetTitle("Server setup\nPick one, or Esc to close");
	menu.AddItem("campaign", "Campaign / map (!maps)");
	menu.AddItem("mode", "Game mode / mutation (!votemode)");
	menu.AddItem("difficulty", "Difficulty");
	menu.AddItem("character", "Change character (!csm)");
	menu.AddItem("gibfest", "Gib Fest + Expert (pick campaign)");
	menu.ExitButton = true;
	menu.Display(client, 45);
}

public int MenuHandler_Setup(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char info[32];
		menu.GetItem(param2, info, sizeof(info));

		if (StrEqual(info, "campaign"))
		{
			FakeClientCommandEx(param1, "sm_maps");
		}
		else if (StrEqual(info, "mode"))
		{
			FakeClientCommandEx(param1, "sm_votemode");
		}
		else if (StrEqual(info, "difficulty"))
		{
			ShowDifficultyMenu(param1);
		}
		else if (StrEqual(info, "character"))
		{
			FakeClientCommandEx(param1, "sm_csm");
		}
		else if (StrEqual(info, "gibfest"))
		{
			ShowGibFestCampaignMenu(param1);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}

	return 0;
}

void ShowGibFestCampaignMenu(int client)
{
	Menu menu = new Menu(MenuHandler_GibFestCampaign);
	menu.SetTitle("Gib Fest + Expert\nChoose campaign");
	menu.AddItem("c1m1_hotel", "Dead Center");
	menu.AddItem("c2m1_highway", "Dark Carnival");
	menu.AddItem("c3m1_plankcountry", "Swamp Fever");
	menu.AddItem("c4m1_milltown_a", "Hard Rain");
	menu.AddItem("c5m1_waterfront", "The Parish");
	menu.AddItem("c6m1_riverbank", "The Passing");
	menu.AddItem("c7m1_docks", "The Sacrifice");
	menu.AddItem("c8m1_apartment", "No Mercy");
	menu.AddItem("c9m1_alleys", "Crash Course");
	menu.AddItem("c10m1_caves", "Death Toll");
	menu.AddItem("c11m1_greenhouse", "Dead Air");
	menu.AddItem("c12m1_hilltop", "Blood Harvest");
	menu.AddItem("c13m1_alpinecreek", "Cold Stream");
	menu.AddItem("c14m1_junkyard", "The Last Stand");
	menu.ExitBackButton = true;
	menu.Display(client, 45);
}

public int MenuHandler_GibFestCampaign(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char map[128];
		char title[64];
		menu.GetItem(param2, map, sizeof(map), _, title, sizeof(title));
		StartGibFestExpertVote(param1, map, title);
	}
	else if (action == MenuAction_Cancel && param2 == MenuCancel_ExitBack)
	{
		ShowSetupMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}

	return 0;
}

void ShowDifficultyMenu(int client)
{
	Menu menu = new Menu(MenuHandler_Difficulty);
	menu.SetTitle("Vote for difficulty");
	menu.AddItem("Easy", "Easy");
	menu.AddItem("Normal", "Normal");
	menu.AddItem("Hard", "Advanced");
	menu.AddItem("Impossible", "Expert");
	menu.ExitBackButton = true;
	menu.Display(client, 30);
}

public int MenuHandler_Difficulty(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char difficulty[32];
		menu.GetItem(param2, difficulty, sizeof(difficulty));
		StartDifficultyVote(param1, difficulty);
	}
	else if (action == MenuAction_Cancel && param2 == MenuCancel_ExitBack)
	{
		ShowSetupMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}

	return 0;
}

void StartGibFestExpertVote(int client, const char[] map, const char[] campaign)
{
	if (IsVoteInProgress())
	{
		PrintToChat(client, "[Setup] A vote is already in progress.");
		return;
	}

	char title[96];
	Format(title, sizeof(title), "Gib Fest + Expert on %s?", campaign);

	Menu vote = new Menu(MenuHandler_GibFestVote);
	vote.SetTitle(title);
	// Winning "Yes" item carries the start map for the chosen campaign.
	vote.AddItem(map, "Yes");
	vote.AddItem("no", "No");
	vote.ExitButton = false;

	int clients[MAXPLAYERS];
	int count;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			clients[count++] = i;
		}
	}

	if (count == 0)
	{
		delete vote;
		return;
	}

	PrintToChatAll("[Setup] %N started a vote: Gib Fest + Expert on %s", client, campaign);
	vote.DisplayVote(clients, count, g_hVoteTime.IntValue);
}

public int MenuHandler_GibFestVote(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_VoteEnd)
	{
		int votes;
		int totalVotes;
		GetMenuVoteInfo(param2, votes, totalVotes);

		char info[128];
		menu.GetItem(param1, info, sizeof(info));

		if (param1 == 0 && !StrEqual(info, "no"))
		{
			ServerCommand("z_difficulty Impossible");
			ServerCommand("sm_cvar mp_gamemode mutation14");
			PrintToChatAll("[Setup] Gib Fest + Expert passed (%d/%d). Changing campaign...", votes, totalVotes);
			DataPack pack = new DataPack();
			pack.WriteString(info);
			CreateTimer(2.0, Timer_ChangeToGibFest, pack, TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			PrintToChatAll("[Setup] Gib Fest + Expert vote failed (%d/%d).", votes, totalVotes);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}

	return 0;
}

public Action Timer_ChangeToGibFest(Handle timer, DataPack pack)
{
	char map[128];
	pack.Reset();
	pack.ReadString(map, sizeof(map));
	delete pack;
	ForceChangeLevel(map, "setup menu gibfest expert");
	return Plugin_Stop;
}

void StartDifficultyVote(int client, const char[] difficulty)
{
	if (IsVoteInProgress())
	{
		PrintToChat(client, "[Setup] A vote is already in progress.");
		return;
	}

	char label[32];
	char title[64];
	GetDifficultyLabel(difficulty, label, sizeof(label));
	Format(title, sizeof(title), "Set difficulty to %s?", label);

	Menu vote = new Menu(MenuHandler_DifficultyVote);
	vote.SetTitle(title);
	vote.AddItem(difficulty, "Yes");
	vote.AddItem("no", "No");
	vote.ExitButton = false;

	int clients[MAXPLAYERS];
	int count;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			clients[count++] = i;
		}
	}

	if (count == 0)
	{
		delete vote;
		return;
	}

	PrintToChatAll("[Setup] %N started a difficulty vote: %s", client, label);
	vote.DisplayVote(clients, count, g_hVoteTime.IntValue);
}

public int MenuHandler_DifficultyVote(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_VoteEnd)
	{
		int votes;
		int totalVotes;
		GetMenuVoteInfo(param2, votes, totalVotes);

		char info[32];
		char label[32];
		menu.GetItem(param1, info, sizeof(info));
		GetDifficultyLabel(info, label, sizeof(label));

		if (param1 == 0 && !StrEqual(info, "no"))
		{
			ServerCommand("z_difficulty %s", info);
			PrintToChatAll("[Setup] Difficulty set to %s (%d/%d).", label, votes, totalVotes);
		}
		else
		{
			PrintToChatAll("[Setup] Difficulty vote failed (%d/%d).", votes, totalVotes);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}

	return 0;
}

void GetDifficultyLabel(const char[] difficulty, char[] label, int maxlen)
{
	if (StrEqual(difficulty, "Easy", false))
	{
		strcopy(label, maxlen, "Easy");
	}
	else if (StrEqual(difficulty, "Hard", false))
	{
		strcopy(label, maxlen, "Advanced");
	}
	else if (StrEqual(difficulty, "Impossible", false))
	{
		strcopy(label, maxlen, "Expert");
	}
	else
	{
		strcopy(label, maxlen, "Normal");
	}
}
