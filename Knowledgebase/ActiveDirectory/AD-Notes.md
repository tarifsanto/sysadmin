# Active Directory Security Lab

## LAB Task Flow:

1. Install DC1:
	- Typical structure of a SME configure for testing and testing from client
	- Find PS script that does the configuration fast
	- Turn on the important events logging
	- Run Bloodhound to get a sescurity overview
	- Run Purple knight and Ping Castle audit: analyse the vuln and try to mitigate
	- Apply the Security measure from Hack The Box AD
	- Run Purpleknight and Ping Castle again and try to improve

	- when satisfied with Purpleknight and Ping Castle then implement Tiering Model
	- Document the steps of tiering
	- Test it with Bloodhound and Purple Knight
	- Test to read the users description to read the written password
	- Bring satisfied result from Bloodhound inspection

	- If it works then write a PS script that creates tiering model including GPO in a single run
	- Test it again
	- Then create a video series on it
	- How about a video on SIEM / Log SRV

	- Simulate Pass The Hash
	- Test if tiering help to overcome the attack


2. Install DHCP SRV:

3. Install DC2 HA:

4. Install DHCP SRV HA:

5.



## Monitor and Audit Tools:
1. https://github.com/ANSSI-FR/ADTimeline
2. Script that detects any changes of memberships in your most privileged groups
3. Purple Knight by Semperis
4. Bloodhound
5. PingCastle
6. ManageEngine all tools: specially -> https://www.manageengine.com/products/self-service-password/download-free.html?btmMenu

## AD Forest Recovery Guide
https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/forest-recovery-guide/ad-forest-recovery-guide


# Guide


## Install DC1

- Install WS 2022 -> Done!
- Change the Hostname and update OS -> Done!
- Setup Static IPv4, Gateways is Router, DNS is Router and WS -> Done!
- Disable IPv6 -> Done!
- Install Active Directory Domain Services with AD DS -> Done!
- After restart check and change DNS Setting: Only DNS Server IP would be the Server IP itself -> Done!
-


# Hardening AD

1. Disable Printer Spooler Service if not required: Open Services -> Disable "printer spooler"
2. Change the default Password Policy (8 Character long, no later than 3 years): https://activedirectorypro.com/how-to-configure-a-domain-password-policy/
   Apply Microsoft Security Baseline ADImport PS to Import the required GPO. The Link them to the Domain Controller and unlink the default domain policy, then gpupdate and take a look again
3.


AD Tiering Guides:
1. https://www.frankysweb.de/active-directory-einfache-manahmen-fr-mehr-sicherheit-teil-1/
2. https://www.frankysweb.de/einfache-massnahmen-fuer-mehr-sicherheit-admin-host/
3. https://www.frankysweb.de/einfache-massnahmen-fuer-mehr-sicherheit-im-ad-teil-3-admin-tiers/
4. https://www.frankysweb.de/einfache-massnahmen-fuer-mehr-sicherheit-im-ad-teil-4-lokale-administratoren/

Privilege Access Security:
1. https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/securing-privileged-access-for-the-ad-admin-part-1/ba-p/259166?WT.mc_id=M365-MVP-6771
2. https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/securing-privileged-access-for-the-ad-admin-part-2/ba-p/259167

Tiering Plan:

WILDCAT
	Administrators
		Admins
			Admin-T1, Admin-T2, Admin-T3 
		AdminsGroups
			AdminsGroup-T1, AdminsGroup-T2, AdminsGroup-T3
	Users
		Management
			Muser1, Muser2 ...
		Sells
			Suser1, Suser2 ...
		Groups
			Mgmnt-Group
			Sells-Group
	ServiceAccounts
		AppSrvc1, AppSrvc2 ...
		
	Workstations (Add all Workstations here by default)
		PC1, PC2, PC3, PC4 ...
	Servers
		Servers-T0
			EX-Srv ...
		Servers-T1
			App-Srv1, App-Srv2 ...
