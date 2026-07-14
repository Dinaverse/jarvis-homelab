#!/usr/bin/env bash
# Run on the Proxmox HOST. Forwards the Ollama port from the host's
# (Tailscale-reachable) address into CT106 so the J.A.R.V.I.S. HUD can reach the
# model through one stable address.
#
# Make it persistent with iptables-persistent, or re-apply on boot.

set -euo pipefail

CT_IP="192.168.1.113"   # CT106 openjarvis
PORT="11434"            # Ollama

iptables -t nat -C PREROUTING -p tcp --dport "${PORT}" \
    -j DNAT --to-destination "${CT_IP}:${PORT}" 2>/dev/null \
  || iptables -t nat -A PREROUTING -p tcp --dport "${PORT}" \
       -j DNAT --to-destination "${CT_IP}:${PORT}"

echo "DNAT active: :${PORT} -> ${CT_IP}:${PORT}"
