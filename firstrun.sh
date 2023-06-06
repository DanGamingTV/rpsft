# this needs to be run as root, in the directory /root
echo "Installing curl"
apt install curl -y
echo "Installing tailscale keys"
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
echo "Running apt update"
apt update -y
echo "Installing tailscale"
apt install tailscale -y
echo "Writing tailscaleup.sh"
echo "tailscale up --advertise-exit-node" > tailscaleup.sh
echo "Making tailscaleup.sh executable"
chmod +x /root/tailscaleup.sh
echo "Enabling ip forwarding for linux"
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
echo "Creating cron job for tailscaleup.sh"
echo "*/10 * * * * /bin/bash /root/tailscaleup.sh >> /root/cron.log 2>&1" | crontab -
echo "Running tailscale up"
tailscale up --advertise-exit-node