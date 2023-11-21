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









## Monitor and Audit Tools:
1. https://github.com/ANSSI-FR/ADTimeline
2. Script that detects any changes of memberships in your most privileged groups
3. Purple Knight by Semperis
4. Bloodhound
5. PingCastle

## AD Forest Recovery Guide
https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/forest-recovery-guide/ad-forest-recovery-guide
