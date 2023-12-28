{ pkgs, ... }:
let
  server = host: {
    config = ''
      client
      dev tun
      proto udp
      remote ${host}.privacy.network 1198
      resolv-retry infinite
      nobind
      persist-key
      persist-tun
      cipher aes-128-cbc
      auth sha1
      tls-client
      remote-cert-tls server

      auth-user-pass ${pkgs.secrets}/openvpn/credentials
      auth-nocache
      compress
      verb 1
      reneg-sec 0
      <crl-verify>
      -----BEGIN X509 CRL-----
      MIICWDCCAUAwDQYJKoZIhvcNAQENBQAwgegxCzAJBgNVBAYTAlVTMQswCQYDVQQI
      EwJDQTETMBEGA1UEBxMKTG9zQW5nZWxlczEgMB4GA1UEChMXUHJpdmF0ZSBJbnRl
      cm5ldCBBY2Nlc3MxIDAeBgNVBAsTF1ByaXZhdGUgSW50ZXJuZXQgQWNjZXNzMSAw
      HgYDVQQDExdQcml2YXRlIEludGVybmV0IEFjY2VzczEgMB4GA1UEKRMXUHJpdmF0
      ZSBJbnRlcm5ldCBBY2Nlc3MxLzAtBgkqhkiG9w0BCQEWIHNlY3VyZUBwcml2YXRl
      aW50ZXJuZXRhY2Nlc3MuY29tFw0xNjA3MDgxOTAwNDZaFw0zNjA3MDMxOTAwNDZa
      MCYwEQIBARcMMTYwNzA4MTkwMDQ2MBECAQYXDDE2MDcwODE5MDA0NjANBgkqhkiG
      9w0BAQ0FAAOCAQEAQZo9X97ci8EcPYu/uK2HB152OZbeZCINmYyluLDOdcSvg6B5
      jI+ffKN3laDvczsG6CxmY3jNyc79XVpEYUnq4rT3FfveW1+Ralf+Vf38HdpwB8EW
      B4hZlQ205+21CALLvZvR8HcPxC9KEnev1mU46wkTiov0EKc+EdRxkj5yMgv0V2Re
      ze7AP+NQ9ykvDScH4eYCsmufNpIjBLhpLE2cuZZXBLcPhuRzVoU3l7A9lvzG9mjA
      5YijHJGHNjlWFqyrn1CfYS6koa4TGEPngBoAziWRbDGdhEgJABHrpoaFYaL61zqy
      MR6jC0K2ps9qyZAN74LEBedEfK7tBOzWMwr58A==
      -----END X509 CRL-----
      </crl-verify>

      <ca>
      -----BEGIN CERTIFICATE-----
      MIIFqzCCBJOgAwIBAgIJAKZ7D5Yv87qDMA0GCSqGSIb3DQEBDQUAMIHoMQswCQYD
      VQQGEwJVUzELMAkGA1UECBMCQ0ExEzARBgNVBAcTCkxvc0FuZ2VsZXMxIDAeBgNV
      BAoTF1ByaXZhdGUgSW50ZXJuZXQgQWNjZXNzMSAwHgYDVQQLExdQcml2YXRlIElu
      dGVybmV0IEFjY2VzczEgMB4GA1UEAxMXUHJpdmF0ZSBJbnRlcm5ldCBBY2Nlc3Mx
      IDAeBgNVBCkTF1ByaXZhdGUgSW50ZXJuZXQgQWNjZXNzMS8wLQYJKoZIhvcNAQkB
      FiBzZWN1cmVAcHJpdmF0ZWludGVybmV0YWNjZXNzLmNvbTAeFw0xNDA0MTcxNzM1
      MThaFw0zNDA0MTIxNzM1MThaMIHoMQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0Ex
      EzARBgNVBAcTCkxvc0FuZ2VsZXMxIDAeBgNVBAoTF1ByaXZhdGUgSW50ZXJuZXQg
      QWNjZXNzMSAwHgYDVQQLExdQcml2YXRlIEludGVybmV0IEFjY2VzczEgMB4GA1UE
      AxMXUHJpdmF0ZSBJbnRlcm5ldCBBY2Nlc3MxIDAeBgNVBCkTF1ByaXZhdGUgSW50
      ZXJuZXQgQWNjZXNzMS8wLQYJKoZIhvcNAQkBFiBzZWN1cmVAcHJpdmF0ZWludGVy
      bmV0YWNjZXNzLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPXD
      L1L9tX6DGf36liA7UBTy5I869z0UVo3lImfOs/GSiFKPtInlesP65577nd7UNzzX
      lH/P/CnFPdBWlLp5ze3HRBCc/Avgr5CdMRkEsySL5GHBZsx6w2cayQ2EcRhVTwWp
      cdldeNO+pPr9rIgPrtXqT4SWViTQRBeGM8CDxAyTopTsobjSiYZCF9Ta1gunl0G/
      8Vfp+SXfYCC+ZzWvP+L1pFhPRqzQQ8k+wMZIovObK1s+nlwPaLyayzw9a8sUnvWB
      /5rGPdIYnQWPgoNlLN9HpSmsAcw2z8DXI9pIxbr74cb3/HSfuYGOLkRqrOk6h4RC
      OfuWoTrZup1uEOn+fw8CAwEAAaOCAVQwggFQMB0GA1UdDgQWBBQv63nQ/pJAt5tL
      y8VJcbHe22ZOsjCCAR8GA1UdIwSCARYwggESgBQv63nQ/pJAt5tLy8VJcbHe22ZO
      sqGB7qSB6zCB6DELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRMwEQYDVQQHEwpM
      b3NBbmdlbGVzMSAwHgYDVQQKExdQcml2YXRlIEludGVybmV0IEFjY2VzczEgMB4G
      A1UECxMXUHJpdmF0ZSBJbnRlcm5ldCBBY2Nlc3MxIDAeBgNVBAMTF1ByaXZhdGUg
      SW50ZXJuZXQgQWNjZXNzMSAwHgYDVQQpExdQcml2YXRlIEludGVybmV0IEFjY2Vz
      czEvMC0GCSqGSIb3DQEJARYgc2VjdXJlQHByaXZhdGVpbnRlcm5ldGFjY2Vzcy5j
      b22CCQCmew+WL/O6gzAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBDQUAA4IBAQAn
      a5PgrtxfwTumD4+3/SYvwoD66cB8IcK//h1mCzAduU8KgUXocLx7QgJWo9lnZ8xU
      ryXvWab2usg4fqk7FPi00bED4f4qVQFVfGfPZIH9QQ7/48bPM9RyfzImZWUCenK3
      7pdw4Bvgoys2rHLHbGen7f28knT2j/cbMxd78tQc20TIObGjo8+ISTRclSTRBtyC
      GohseKYpTS9himFERpUgNtefvYHbn70mIOzfOJFTVqfrptf9jXa9N8Mpy3ayfodz
      1wiqdteqFXkTYoSDctgKMiZ6GdocK9nMroQipIQtpnwd4yBDWIyC6Bvlkrq5TQUt
      YDQ8z9v+DMO6iwyIDRiU
      -----END CERTIFICATE-----
      </ca>

      disable-occ
    '';

    autoStart = true;
    updateResolvConf = false;
  };
in
{
  services.openvpn.servers = {
    switzerland = server "swiss";
    /* poland = server "poland"; */
    /* spain = server "spain"; */
  };

  # will get automatically mounted in openvpn namespace
  environment.etc."netns/openvpn/resolv.conf".text = ''
    nameserver 1.1.1.1
    nameserver 1.0.0.1
  '';

  systemd.services.openvpn-switzerland = {
    bindsTo = [ "vpn-namespace.service" ];
    after = [ "vpn-namespace.service" ];
    unitConfig.JoinsNamespaceOf = "netns@openvpn.service";
    serviceConfig.PrivateNetwork = true;
  };

  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      PrivateNetwork = true;
      ExecStart = with pkgs; "${writers.writeBash "netns-up" ''
        ${iproute2}/bin/ip netns add $1
        ${util-linux}/bin/umount /var/run/netns/$1
        ${util-linux}/bin/mount --bind /proc/self/ns/net /var/run/netns/$1
      ''} %I";
      ExecStop = with pkgs; "${iproute2}/bin/ip netns del %I";
    };
  };

  systemd.services.vpn-namespace =
    {
      description = "openvpn network namespace";
      bindsTo = [ "netns@openvpn.service" ];
      requires = [ "network-online.target" ];
      after = [ "netns@openvpn.service" ];
      before = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = with pkgs; writers.writeBash "create-netns" ''
          ${iproute2}/bin/ip link add veth-vpn netns openvpn type veth peer name host-vpn netns 1
          ${iproute2}/bin/ip -n openvpn addr add 127.0.0.1/8 dev lo
          ${iproute2}/bin/ip -n openvpn link set dev lo up
          ${iproute2}/bin/ip -n openvpn addr add 10.0.0.50/24 dev veth-vpn
          ${iproute2}/bin/ip -n openvpn link set veth-vpn up
          ${iproute2}/bin/ip -n openvpn route add default via 10.0.0.55 dev veth-vpn

          ${iproute2}/bin/ip link set host-vpn up
          ${iproute2}/bin/ip addr add 10.0.0.55/24 dev host-vpn
          
          # nzbget
          ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 6789 -j DNAT --to-destination 10.0.0.50:6789
          # sonarr
          ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 8989 -j DNAT --to-destination 10.0.0.50:8989
          # radarr
          ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 7878 -j DNAT --to-destination 10.0.0.50:7878
          # prowlarr
          ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 9696 -j DNAT --to-destination 10.0.0.50:9696

          # net namespace
          ${iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -j MASQUERADE
          # bridge interface
          ${iptables}/bin/iptables -t nat -A POSTROUTING -s 10.11.0.0/24 -j MASQUERADE
          # tailscale interface
          ${iptables}/bin/iptables -t nat -A POSTROUTING -o tailscale0 -j MASQUERADE

          ${procps}/bin/sysctl -w net.ipv4.ip_forward=1
        '';
        ExecStop = with pkgs; writers.writeBash "wg-down" ''
          ${iproute2}/bin/ip -n openvpn link del veth-vpn
          ${iproute2}/bin/ip -n openvpn route del default dev veth-vpn

          ${iproute2}/bin/ip link delete host-vpn

          # nzbget
          ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dport 6789 -j DNAT --to-destination 10.0.0.50:6789
          # sonarr
          ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dport 8989 -j DNAT --to-destination 10.0.0.50:8989
          # radarr
          ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dport 7878 -j DNAT --to-destination 10.0.0.50:7878
          # prowlarr
          ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dport 9696 -j DNAT --to-destination 10.0.0.50:9696

          # net namespace
          ${iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -j MASQUERADE
          # bridge interface
          ${iptables}/bin/iptables -t nat -D POSTROUTING -s 10.11.0.0/24 -j MASQUERADE
          # tailscale interface
          ${iptables}/bin/iptables -t nat -D POSTROUTING -o tailscale0 -j MASQUERADE
        '';
      };
    };
}
