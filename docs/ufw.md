# Lock down the system with UFW

Only allow traffic from tailscale interface, and 8920 for jellyfin.

```bash
sudo ufw enable
sudo ufw allow in on tailscale0 comment "tailscale interface"
sudo ufw allow 41641/udp comment "tailscale public port"
sudo ufw allow from any proto tcp to any port 8920 comment "jellyfin"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw status verbose
sudo ufw reload
```
