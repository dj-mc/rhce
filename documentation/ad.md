# Active Directory (AD)

AD integration bridges the gap between machines running different operating systems.

## The AD Provider

- enables SSSD to use the LDAP identity provider
- and the Kerberos authentication provider, optimized for an AD environment
- Linux uses a POSIX compliant `User/Group ID` (`UID` and `GID`)
- Windows uses a `Security ID` (`SID`)
- Do not use the same name in both Windows and AD

Generate UIDs and GIDs for AD users:

- Assigns a range of available IDs to new domains
- Each domain will have the same ID range on every SSSD client
- SSSD creates entries (cached) for AD users logging in for the 1st time
- Their UID is created based on their SID the domain's ID range
- A user should have the same UID and GID for all RHEL systems

## System Security Services Daemon (SSSD)

- Access remote directories and authentication mechanisms
- Connect a local system (SSSD client) to a backend (domain)
- Access remote services
  - LDAP directory
  - identity management
  - active directory
  - Kerberos realm

If `/etc/sssd/sssd.conf` has:

```conf
id_provider = ad
```

How SSSD will handle trusted domains:

- Supports (and will discover all) domains from a single AD forest
- Will resolve requests for objects located in a trusted domain
- You can use `ad_enabled_domains` in `/etc/sssd/sssd.conf`
  - to control from which trusted domains SSSD should resolve
- You should use fully-qualified names for users

Configure an AD domain with ID mapping as a provider for SSSD:

- Verify DNS SRV LDAP records
  - `# dig -t SRV _ldap._tcp.ad.example.com`
- Verify AD records
  - `# dig -t SRV _ldap._tcp.dc._msdcs.ad.example.com`
- Verify that time is synchronized across both systems
- Ensure the AD domain controller's ports are accessible to the RHEL host

| Service  | Port | Protocol  | Notes            |
| -------- | ---- | --------- | ---------------- |
| DNS      | 53   | UDP & TCP |                  |
| LDAP     | 389  | UDP & TCP |                  |
| Kerberos | 88   | UDP & TCP |                  |
| Kerberos | 464  | UDP & TCP | kadmin password  |
| LDAP GC  | 3268 | TCP       | id_provider = ad |
| NTP      | 123  | UDP       | Optional         |
| Samba    | 445  | UDP & TCP | AD GPOs          |

## realmd (Direct Domain Integration)

`# realmd join ad.example.com`

- Direct domain integration
- Discover and join identity domains
- Configures SSSD, Winbind, etc. to connect to domains
- Set up services needed to connect and manage user access
- SSSD is an underlying service, which can support multiple domains

Supports:

- Microsoft AD
- RHEL Identity Management

Supported clients:

- SSSD for both MS AD and RHEL IdM
- Winbind for MS AD

## Samba (Active Directory Integration)

- Implements Server Message Block (SMB) protocol in RHEL
- Access resources on a server, like file shares and shared printers
- Authenticate AD domain users to a domain controller (DC)
