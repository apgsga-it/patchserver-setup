# This file was automatically generated on 2020-06-17 14:17:57 +0200.
# Use the 'puppet generate types' command to regenerate this file.

# @summary
#   This type provides the capability to manage firewall rules within puppet.
# 
# **Autorequires:**
# 
# If Puppet is managing the iptables or ip6tables chains specified in the
# `chain` or `jump` parameters, the firewall resource will autorequire
# those firewallchain resources.
# 
# If Puppet is managing the iptables, iptables-persistent, or iptables-services packages,
# and the provider is iptables or ip6tables, the firewall resource will
# autorequire those packages to ensure that any required binaries are
# installed.
# 
# #### Providers
#   Note: Not all features are available with all providers.
# 
#   * ip6tables: Ip6tables type provider
# 
#     * Required binaries: ip6tables-save, ip6tables.
#     * Supported features: address_type, connection_limiting, conntrack, dnat, hop_limiting, icmp_match,
#     interface_match, iprange, ipsec_dir, ipsec_policy, ipset, iptables, isfirstfrag,
#     ishasmorefrags, islastfrag, length, log_level, log_prefix, log_uid,
#     log_tcp_sequence, log_tcp_options, log_ip_options, mask, mss,
#     owner, pkttype, queue_bypass, queue_num, rate_limiting, recent_limiting, reject_type,
#     snat, socket, state_match, string_matching, tcp_flags, hashlimit, bpf.
# 
#   * iptables: Iptables type provider
# 
#     * Required binaries: iptables-save, iptables.
#     * Default for kernel == linux.
#     * Supported features: address_type, clusterip, connection_limiting, conntrack, dnat, icmp_match,
#     interface_match, iprange, ipsec_dir, ipsec_policy, ipset, iptables, isfragment, length,
#     log_level, log_prefix, log_uid, log_tcp_sequence, log_tcp_options, log_ip_options,
#     mark, mask, mss, netmap, nflog_group, nflog_prefix,
#     nflog_range, nflog_threshold, owner, pkttype, queue_bypass, queue_num, rate_limiting,
#     recent_limiting, reject_type, snat, socket, state_match, string_matching, tcp_flags, bpf.
# 
# #### Features
#   * address_type: The ability to match on source or destination address type.
# 
#   * clusterip: Configure a simple cluster of nodes that share a certain IP and MAC address without an explicit load balancer in front of them.
# 
#   * connection_limiting: Connection limiting features.
# 
#   * conntrack: Connection tracking features.
# 
#   * dnat: Destination NATing.
# 
#   * hop_limiting: Hop limiting features.
# 
#   * icmp_match: The ability to match ICMP types.
# 
#   * interface_match: Interface matching.
# 
#   * iprange: The ability to match on source or destination IP range.
# 
#   * ipsec_dir: The ability to match IPsec policy direction.
# 
#   * ipsec_policy: The ability to match IPsec policy.
# 
#   * iptables: The provider provides iptables features.
# 
#   * isfirstfrag: The ability to match the first fragment of a fragmented ipv6 packet.
# 
#   * isfragment: The ability to match fragments.
# 
#   * ishasmorefrags: The ability to match a non-last fragment of a fragmented ipv6 packet.
# 
#   * islastfrag: The ability to match the last fragment of an ipv6 packet.
# 
#   * length: The ability to match the length of the layer-3 payload.
# 
#   * log_level: The ability to control the log level.
# 
#   * log_prefix: The ability to add prefixes to log messages.
# 
#   * log_uid: The ability to log the userid of the process which generated the packet.
# 
#   * log_tcp_sequence: The ability to log TCP sequence numbers.
# 
#   * log_tcp_options: The ability to log TCP packet header.
# 
#   * log_ip_options: The ability to log IP/IPv6 packet header.
# 
#   * mark: The ability to match or set the netfilter mark value associated with the packet.
# 
#   * mask: The ability to match recent rules based on the ipv4 mask.
# 
#   * nflog_group: The ability to set the group number for NFLOG.
# 
#   * nflog_prefix: The ability to set a prefix for nflog messages.
# 
#   * nflog_range: The ability to set nflog_range.
# 
#   * nflog_threshold: The ability to set nflog_threshold.
# 
#   * owner: The ability to match owners.
# 
#   * pkttype: The ability to match a packet type.
# 
#   * rate_limiting: Rate limiting features.
# 
#   * recent_limiting: The netfilter recent module.
# 
#   * reject_type: The ability to control reject messages.
# 
#   * set_mss: Set the TCP MSS of a packet.
# 
#   * snat: Source NATing.
# 
#   * socket: The ability to match open sockets.
# 
#   * state_match: The ability to match stateful firewall states.
# 
#   * string_matching: The ability to match a given string by using some pattern matching strategy.
# 
#   * tcp_flags: The ability to match on particular TCP flag settings.
# 
#   * netmap: The ability to map entire subnets via source or destination nat rules.
# 
#   * hashlimit: The ability to use the hashlimit-module.
# 
#   * bpf: The ability to use Berkeley Paket Filter rules.
# 
#   * ipvs: The ability to match IP Virtual Server packets.
# 
#   * ct_target: The ability to set connection tracking parameters for a packet or its associated connection.
# 
#   * random_fully: The ability to use --random-fully flag.
Puppet::Resource::ResourceType3.new(
  'firewall',
  [
    # Manage the state of this rule.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # This is the action to perform on a match. Can be one of:
    # 
    # * accept - the packet is accepted
    # * reject - the packet is rejected with a suitable ICMP response
    # * drop - the packet is dropped
    # 
    # If you specify no value it will simply match the rule but perform no
    # action unless you provide a provider specific parameter (such as *jump*).
    # 
    # Valid values are `accept`, `reject`, `drop`.
    Puppet::Resource::Param(Enum['accept', 'reject', 'drop'], 'action'),

    # The source address. For example:
    # 
    #     source => '192.168.2.0/24'
    # 
    # You can also negate a mask by putting ! in front. For example:
    # 
    #     source => '! 192.168.2.0/24'
    # 
    # The source can also be an IPv6 address if your provider supports it.
    Puppet::Resource::Param(Any, 'source'),

    # The source IP range. For example:
    # 
    #     src_range => '192.168.1.1-192.168.1.10'
    # 
    # The source IP range must be in 'IP1-IP2' format.
    # 
    # 
    # 
    # Requires features iprange.
    Puppet::Resource::Param(Any, 'src_range'),

    # The destination address to match. For example:
    # 
    #     destination => '192.168.1.0/24'
    # 
    # You can also negate a mask by putting ! in front. For example:
    # 
    #     destination  => '! 192.168.2.0/24'
    # 
    # The destination can also be an IPv6 address if your provider supports it.
    Puppet::Resource::Param(Any, 'destination'),

    # The destination IP range. For example:
    # 
    #     dst_range => '192.168.1.1-192.168.1.10'
    # 
    # The destination IP range must be in 'IP1-IP2' format.
    # 
    # 
    # 
    # Requires features iprange.
    Puppet::Resource::Param(Any, 'dst_range'),

    # The source port to match for this filter (if the protocol supports
    # ports). Will accept a single element or an array.
    # 
    # For some firewall providers you can pass a range of ports in the format:
    # 
    #     <start_number>-<ending_number>
    # 
    # For example:
    # 
    #     1-1024
    # 
    # This would cover ports 1 to 1024.
    Puppet::Resource::Param(Any, 'sport'),

    # The destination port to match for this filter (if the protocol supports
    # ports). Will accept a single element or an array.
    # 
    # For some firewall providers you can pass a range of ports in the format:
    # 
    #     <start_number>-<ending_number>
    # 
    # For example:
    # 
    #     1-1024
    # 
    # This would cover ports 1 to 1024.
    Puppet::Resource::Param(Any, 'dport'),

    # *note* This property has been DEPRECATED
    # 
    # The destination or source port to match for this filter (if the protocol
    # supports ports). Will accept a single element or an array.
    # 
    # For some firewall providers you can pass a range of ports in the format:
    # 
    #     <start_number>-<ending_number>
    # 
    # For example:
    # 
    #     1-1024
    # 
    # This would cover ports 1 to 1024.
    Puppet::Resource::Param(Any, 'port'),

    # The destination address type. For example:
    # 
    #     dst_type => ['LOCAL']
    # 
    # Can be one of:
    # 
    # * UNSPEC - an unspecified address
    # * UNICAST - a unicast address
    # * LOCAL - a local address
    # * BROADCAST - a broadcast address
    # * ANYCAST - an anycast packet
    # * MULTICAST - a multicast address
    # * BLACKHOLE - a blackhole address
    # * UNREACHABLE - an unreachable address
    # * PROHIBIT - a prohibited address
    # * THROW - undocumented
    # * NAT - undocumented
    # * XRESOLVE - undocumented
    # 
    # In addition, it accepts '--limit-iface-in' and '--limit-iface-out' flags, specified as:
    # 
    #     dst_type => ['LOCAL --limit-iface-in']
    # 
    # It can also be negated using '!':
    # 
    #     dst_type => ['! LOCAL']
    # 
    # Will accept a single element or an array.
    # 
    # Valid values are `UNSPEC`, `! UNSPEC`, `UNSPEC --limit-iface-in`, `UNSPEC --limit-iface-out`, `! UNSPEC --limit-iface-in`, `! UNSPEC --limit-iface-out`, `UNICAST`, `! UNICAST`, `UNICAST --limit-iface-in`, `UNICAST --limit-iface-out`, `! UNICAST --limit-iface-in`, `! UNICAST --limit-iface-out`, `LOCAL`, `! LOCAL`, `LOCAL --limit-iface-in`, `LOCAL --limit-iface-out`, `! LOCAL --limit-iface-in`, `! LOCAL --limit-iface-out`, `BROADCAST`, `! BROADCAST`, `BROADCAST --limit-iface-in`, `BROADCAST --limit-iface-out`, `! BROADCAST --limit-iface-in`, `! BROADCAST --limit-iface-out`, `ANYCAST`, `! ANYCAST`, `ANYCAST --limit-iface-in`, `ANYCAST --limit-iface-out`, `! ANYCAST --limit-iface-in`, `! ANYCAST --limit-iface-out`, `MULTICAST`, `! MULTICAST`, `MULTICAST --limit-iface-in`, `MULTICAST --limit-iface-out`, `! MULTICAST --limit-iface-in`, `! MULTICAST --limit-iface-out`, `BLACKHOLE`, `! BLACKHOLE`, `BLACKHOLE --limit-iface-in`, `BLACKHOLE --limit-iface-out`, `! BLACKHOLE --limit-iface-in`, `! BLACKHOLE --limit-iface-out`, `UNREACHABLE`, `! UNREACHABLE`, `UNREACHABLE --limit-iface-in`, `UNREACHABLE --limit-iface-out`, `! UNREACHABLE --limit-iface-in`, `! UNREACHABLE --limit-iface-out`, `PROHIBIT`, `! PROHIBIT`, `PROHIBIT --limit-iface-in`, `PROHIBIT --limit-iface-out`, `! PROHIBIT --limit-iface-in`, `! PROHIBIT --limit-iface-out`, `THROW`, `! THROW`, `THROW --limit-iface-in`, `THROW --limit-iface-out`, `! THROW --limit-iface-in`, `! THROW --limit-iface-out`, `NAT`, `! NAT`, `NAT --limit-iface-in`, `NAT --limit-iface-out`, `! NAT --limit-iface-in`, `! NAT --limit-iface-out`, `XRESOLVE`, `! XRESOLVE`, `XRESOLVE --limit-iface-in`, `XRESOLVE --limit-iface-out`, `! XRESOLVE --limit-iface-in`, `! XRESOLVE --limit-iface-out`. 
    # 
    # Requires features address_type.
    Puppet::Resource::Param(Enum['UNSPEC', '! UNSPEC', 'UNSPEC --limit-iface-in', 'UNSPEC --limit-iface-out', '! UNSPEC --limit-iface-in', '! UNSPEC --limit-iface-out', 'UNICAST', '! UNICAST', 'UNICAST --limit-iface-in', 'UNICAST --limit-iface-out', '! UNICAST --limit-iface-in', '! UNICAST --limit-iface-out', 'LOCAL', '! LOCAL', 'LOCAL --limit-iface-in', 'LOCAL --limit-iface-out', '! LOCAL --limit-iface-in', '! LOCAL --limit-iface-out', 'BROADCAST', '! BROADCAST', 'BROADCAST --limit-iface-in', 'BROADCAST --limit-iface-out', '! BROADCAST --limit-iface-in', '! BROADCAST --limit-iface-out', 'ANYCAST', '! ANYCAST', 'ANYCAST --limit-iface-in', 'ANYCAST --limit-iface-out', '! ANYCAST --limit-iface-in', '! ANYCAST --limit-iface-out', 'MULTICAST', '! MULTICAST', 'MULTICAST --limit-iface-in', 'MULTICAST --limit-iface-out', '! MULTICAST --limit-iface-in', '! MULTICAST --limit-iface-out', 'BLACKHOLE', '! BLACKHOLE', 'BLACKHOLE --limit-iface-in', 'BLACKHOLE --limit-iface-out', '! BLACKHOLE --limit-iface-in', '! BLACKHOLE --limit-iface-out', 'UNREACHABLE', '! UNREACHABLE', 'UNREACHABLE --limit-iface-in', 'UNREACHABLE --limit-iface-out', '! UNREACHABLE --limit-iface-in', '! UNREACHABLE --limit-iface-out', 'PROHIBIT', '! PROHIBIT', 'PROHIBIT --limit-iface-in', 'PROHIBIT --limit-iface-out', '! PROHIBIT --limit-iface-in', '! PROHIBIT --limit-iface-out', 'THROW', '! THROW', 'THROW --limit-iface-in', 'THROW --limit-iface-out', '! THROW --limit-iface-in', '! THROW --limit-iface-out', 'NAT', '! NAT', 'NAT --limit-iface-in', 'NAT --limit-iface-out', '! NAT --limit-iface-in', '! NAT --limit-iface-out', 'XRESOLVE', '! XRESOLVE', 'XRESOLVE --limit-iface-in', 'XRESOLVE --limit-iface-out', '! XRESOLVE --limit-iface-in', '! XRESOLVE --limit-iface-out'], 'dst_type'),

    # The source address type. For example:
    # 
    #     src_type => ['LOCAL']
    # 
    # Can be one of:
    # 
    # * UNSPEC - an unspecified address
    # * UNICAST - a unicast address
    # * LOCAL - a local address
    # * BROADCAST - a broadcast address
    # * ANYCAST - an anycast packet
    # * MULTICAST - a multicast address
    # * BLACKHOLE - a blackhole address
    # * UNREACHABLE - an unreachable address
    # * PROHIBIT - a prohibited address
    # * THROW - undocumented
    # * NAT - undocumented
    # * XRESOLVE - undocumented
    # 
    # In addition, it accepts '--limit-iface-in' and '--limit-iface-out' flags, specified as:
    # 
    #     src_type => ['LOCAL --limit-iface-in']
    # 
    # It can also be negated using '!':
    # 
    #     src_type => ['! LOCAL']
    # 
    # Will accept a single element or an array.
    # 
    # Valid values are `UNSPEC`, `! UNSPEC`, `UNSPEC --limit-iface-in`, `UNSPEC --limit-iface-out`, `! UNSPEC --limit-iface-in`, `! UNSPEC --limit-iface-out`, `UNICAST`, `! UNICAST`, `UNICAST --limit-iface-in`, `UNICAST --limit-iface-out`, `! UNICAST --limit-iface-in`, `! UNICAST --limit-iface-out`, `LOCAL`, `! LOCAL`, `LOCAL --limit-iface-in`, `LOCAL --limit-iface-out`, `! LOCAL --limit-iface-in`, `! LOCAL --limit-iface-out`, `BROADCAST`, `! BROADCAST`, `BROADCAST --limit-iface-in`, `BROADCAST --limit-iface-out`, `! BROADCAST --limit-iface-in`, `! BROADCAST --limit-iface-out`, `ANYCAST`, `! ANYCAST`, `ANYCAST --limit-iface-in`, `ANYCAST --limit-iface-out`, `! ANYCAST --limit-iface-in`, `! ANYCAST --limit-iface-out`, `MULTICAST`, `! MULTICAST`, `MULTICAST --limit-iface-in`, `MULTICAST --limit-iface-out`, `! MULTICAST --limit-iface-in`, `! MULTICAST --limit-iface-out`, `BLACKHOLE`, `! BLACKHOLE`, `BLACKHOLE --limit-iface-in`, `BLACKHOLE --limit-iface-out`, `! BLACKHOLE --limit-iface-in`, `! BLACKHOLE --limit-iface-out`, `UNREACHABLE`, `! UNREACHABLE`, `UNREACHABLE --limit-iface-in`, `UNREACHABLE --limit-iface-out`, `! UNREACHABLE --limit-iface-in`, `! UNREACHABLE --limit-iface-out`, `PROHIBIT`, `! PROHIBIT`, `PROHIBIT --limit-iface-in`, `PROHIBIT --limit-iface-out`, `! PROHIBIT --limit-iface-in`, `! PROHIBIT --limit-iface-out`, `THROW`, `! THROW`, `THROW --limit-iface-in`, `THROW --limit-iface-out`, `! THROW --limit-iface-in`, `! THROW --limit-iface-out`, `NAT`, `! NAT`, `NAT --limit-iface-in`, `NAT --limit-iface-out`, `! NAT --limit-iface-in`, `! NAT --limit-iface-out`, `XRESOLVE`, `! XRESOLVE`, `XRESOLVE --limit-iface-in`, `XRESOLVE --limit-iface-out`, `! XRESOLVE --limit-iface-in`, `! XRESOLVE --limit-iface-out`. 
    # 
    # Requires features address_type.
    Puppet::Resource::Param(Enum['UNSPEC', '! UNSPEC', 'UNSPEC --limit-iface-in', 'UNSPEC --limit-iface-out', '! UNSPEC --limit-iface-in', '! UNSPEC --limit-iface-out', 'UNICAST', '! UNICAST', 'UNICAST --limit-iface-in', 'UNICAST --limit-iface-out', '! UNICAST --limit-iface-in', '! UNICAST --limit-iface-out', 'LOCAL', '! LOCAL', 'LOCAL --limit-iface-in', 'LOCAL --limit-iface-out', '! LOCAL --limit-iface-in', '! LOCAL --limit-iface-out', 'BROADCAST', '! BROADCAST', 'BROADCAST --limit-iface-in', 'BROADCAST --limit-iface-out', '! BROADCAST --limit-iface-in', '! BROADCAST --limit-iface-out', 'ANYCAST', '! ANYCAST', 'ANYCAST --limit-iface-in', 'ANYCAST --limit-iface-out', '! ANYCAST --limit-iface-in', '! ANYCAST --limit-iface-out', 'MULTICAST', '! MULTICAST', 'MULTICAST --limit-iface-in', 'MULTICAST --limit-iface-out', '! MULTICAST --limit-iface-in', '! MULTICAST --limit-iface-out', 'BLACKHOLE', '! BLACKHOLE', 'BLACKHOLE --limit-iface-in', 'BLACKHOLE --limit-iface-out', '! BLACKHOLE --limit-iface-in', '! BLACKHOLE --limit-iface-out', 'UNREACHABLE', '! UNREACHABLE', 'UNREACHABLE --limit-iface-in', 'UNREACHABLE --limit-iface-out', '! UNREACHABLE --limit-iface-in', '! UNREACHABLE --limit-iface-out', 'PROHIBIT', '! PROHIBIT', 'PROHIBIT --limit-iface-in', 'PROHIBIT --limit-iface-out', '! PROHIBIT --limit-iface-in', '! PROHIBIT --limit-iface-out', 'THROW', '! THROW', 'THROW --limit-iface-in', 'THROW --limit-iface-out', '! THROW --limit-iface-in', '! THROW --limit-iface-out', 'NAT', '! NAT', 'NAT --limit-iface-in', 'NAT --limit-iface-out', '! NAT --limit-iface-in', '! NAT --limit-iface-out', 'XRESOLVE', '! XRESOLVE', 'XRESOLVE --limit-iface-in', 'XRESOLVE --limit-iface-out', '! XRESOLVE --limit-iface-in', '! XRESOLVE --limit-iface-out'], 'src_type'),

    # The specific protocol to match for this rule.
    # 
    # Valid values are `ip`, `! ip`, `tcp`, `! tcp`, `udp`, `! udp`, `icmp`, `! icmp`, `ipv6-icmp`, `! ipv6-icmp`, `esp`, `! esp`, `ah`, `! ah`, `vrrp`, `! vrrp`, `igmp`, `! igmp`, `ipencap`, `! ipencap`, `ipv4`, `! ipv4`, `ipv6`, `! ipv6`, `ospf`, `! ospf`, `gre`, `! gre`, `cbt`, `! cbt`, `sctp`, `! sctp`, `pim`, `! pim`, `all`, `! all`.
    Puppet::Resource::Param(Enum['ip', '! ip', 'tcp', '! tcp', 'udp', '! udp', 'icmp', '! icmp', 'ipv6-icmp', '! ipv6-icmp', 'esp', '! esp', 'ah', '! ah', 'vrrp', '! vrrp', 'igmp', '! igmp', 'ipencap', '! ipencap', 'ipv4', '! ipv4', 'ipv6', '! ipv6', 'ospf', '! ospf', 'gre', '! gre', 'cbt', '! cbt', 'sctp', '! sctp', 'pim', '! pim', 'all', '! all'], 'proto'),

    # Match a given TCP MSS value or range.
    Puppet::Resource::Param(Any, 'mss'),

    # Match when the TCP flags are as specified.
    # Is a string with a list of comma-separated flag names for the mask,
    # then a space, then a comma-separated list of flags that should be set.
    # The flags are: SYN ACK FIN RST URG PSH ALL NONE
    # Note that you specify them in the order that iptables --list-rules
    # would list them to avoid having puppet think you changed the flags.
    # Example: FIN,SYN,RST,ACK SYN matches packets with the SYN bit set and the
    # ACK,RST and FIN bits cleared. Such packets are used to request
    # TCP  connection initiation.
    # 
    # 
    # 
    # Requires features tcp_flags.
    Puppet::Resource::Param(Any, 'tcp_flags'),

    # Name of the chain to use. Can be one of the built-ins:
    # 
    # * INPUT
    # * FORWARD
    # * OUTPUT
    # * PREROUTING
    # * POSTROUTING
    # 
    # Or you can provide a user-based chain.
    # 
    # Values can match `/^[a-zA-Z0-9\-_]+$/`.
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Pattern[/^[a-zA-Z0-9\-_]+$/], 'chain'),

    # Table to use. Can be one of:
    # 
    # * nat
    # * mangle
    # * filter
    # * raw
    # * rawpost
    # 
    # Valid values are `nat`, `mangle`, `filter`, `raw`, `rawpost`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Enum['nat', 'mangle', 'filter', 'raw', 'rawpost'], 'table'),

    # The value for the iptables --jump parameter. Normal values are:
    # 
    # * QUEUE
    # * RETURN
    # * DNAT
    # * SNAT
    # * LOG
    # * NFLOG
    # * MASQUERADE
    # * REDIRECT
    # * MARK
    # * CT
    # 
    # But any valid chain name is allowed.
    # 
    # For the values ACCEPT, DROP, and REJECT, you must use the generic
    # 'action' parameter. This is to enfore the use of generic parameters where
    # possible for maximum cross-platform modelling.
    # 
    # If you set both 'accept' and 'jump' parameters, you will get an error as
    # only one of the options should be set.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'jump'),

    # The value for the iptables --goto parameter. Normal values are:
    # 
    # * QUEUE
    # * RETURN
    # * DNAT
    # * SNAT
    # * LOG
    # * MASQUERADE
    # * REDIRECT
    # * MARK
    # 
    # But any valid chain name is allowed.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'goto'),

    # Input interface to filter on.  Supports interface alias like eth0:0.
    # To negate the match try this:
    # 
    #       iniface => '! lo',
    # 
    # Values can match `/^!?\s?[a-zA-Z0-9\-\._\+\:@]+$/`.
    # 
    # Requires features interface_match.
    Puppet::Resource::Param(Pattern[/^!?\s?[a-zA-Z0-9\-\._\+\:@]+$/], 'iniface'),

    # Output interface to filter on.  Supports interface alias like eth0:0.
    # To negate the match try this:
    # 
    #       outiface => '! lo',
    # 
    # Values can match `/^!?\s?[a-zA-Z0-9\-\._\+\:@]+$/`.
    # 
    # Requires features interface_match.
    Puppet::Resource::Param(Pattern[/^!?\s?[a-zA-Z0-9\-\._\+\:@]+$/], 'outiface'),

    # When using jump => "SNAT" you can specify the new source address using
    # this parameter.
    # 
    # 
    # 
    # Requires features snat.
    Puppet::Resource::Param(Any, 'tosource'),

    # When using jump => "DNAT" you can specify the new destination address
    # using this paramter.
    # 
    # 
    # 
    # Requires features dnat.
    Puppet::Resource::Param(Any, 'todest'),

    # For DNAT this is the port that will replace the destination port.
    # 
    # 
    # 
    # Requires features dnat.
    Puppet::Resource::Param(Any, 'toports'),

    # For NETMAP this will replace the destination IP
    # 
    # 
    # 
    # Requires features netmap.
    Puppet::Resource::Param(Any, 'to'),

    # When using a jump value of "MASQUERADE", "DNAT", "REDIRECT", or "SNAT"
    # this boolean will enable fully randomized port mapping.
    # 
    # **NOTE** Requires Kernel >= 3.13 and iptables >= 1.6.2
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features random_fully.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'random_fully'),

    # When using a jump value of "MASQUERADE", "DNAT", "REDIRECT", or "SNAT"
    # this boolean will enable randomized port mapping.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features dnat.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'random'),

    # When combined with action => "REJECT" you can specify a different icmp
    # response to be sent back to the packet sender.
    # 
    # 
    # 
    # Requires features reject_type.
    Puppet::Resource::Param(Any, 'reject'),

    # When combined with jump => "LOG" specifies the system log level to log
    # to.
    # 
    # 
    # 
    # Requires features log_level.
    Puppet::Resource::Param(Any, 'log_level'),

    # When combined with jump => "LOG" specifies the log prefix to use when
    # logging.
    # 
    # 
    # 
    # Requires features log_prefix.
    Puppet::Resource::Param(Any, 'log_prefix'),

    # When combined with jump => "LOG" specifies the uid of the process making
    # the connection.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features log_uid.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'log_uid'),

    # When combined with jump => "LOG" enables logging of the TCP sequence
    # numbers.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features log_tcp_sequence.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'log_tcp_sequence'),

    # When combined with jump => "LOG" logging of the TCP packet
    # header.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features log_tcp_options.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'log_tcp_options'),

    # When combined with jump => "LOG" logging of the TCP IP/IPv6
    # packet header.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features log_ip_options.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'log_ip_options'),

    # Used with the jump target NFLOG.
    # The netlink group (0 - 2^16-1) to which packets are (only applicable
    # for nfnetlink_log). Defaults to 0.
    # 
    # 
    # 
    # Requires features nflog_group.
    Puppet::Resource::Param(Any, 'nflog_group'),

    # Used with the jump target NFLOG.
    # A prefix string to include in the log message, up to 64 characters long,
    # useful for distinguishing messages in the logs.
    # 
    # 
    # 
    # Requires features nflog_prefix.
    Puppet::Resource::Param(Any, 'nflog_prefix'),

    # Used with the jump target NFLOG.
    # The number of bytes to be copied to userspace (only applicable for nfnetlink_log).
    # nfnetlink_log instances may specify their own range, this option overrides it.
    # 
    # 
    # 
    # Requires features nflog_range.
    Puppet::Resource::Param(Any, 'nflog_range'),

    # Used with the jump target NFLOG.
    # Number of packets to queue inside the kernel before sending them to userspace
    # (only applicable for nfnetlink_log). Higher values result in less overhead
    # per packet, but increase delay until the packets reach userspace. Defaults to 1.
    # 
    # 
    # 
    # Requires features nflog_threshold.
    Puppet::Resource::Param(Any, 'nflog_threshold'),

    # When matching ICMP packets, this is the type of ICMP packet to match.
    # 
    # A value of "any" is not supported. To achieve this behaviour the
    # parameter should simply be omitted or undefined.
    # An array of values is also not supported. To match against multiple ICMP
    # types, please use separate rules for each ICMP type.
    # 
    # 
    # 
    # Requires features icmp_match.
    Puppet::Resource::Param(Any, 'icmp'),

    # Matches a packet based on its state in the firewall stateful inspection
    # table. Values can be:
    # 
    # * INVALID
    # * ESTABLISHED
    # * NEW
    # * RELATED
    # * UNTRACKED
    # 
    # Valid values are `INVALID`, `ESTABLISHED`, `NEW`, `RELATED`, `UNTRACKED`. 
    # 
    # Requires features state_match.
    Puppet::Resource::Param(Enum['INVALID', 'ESTABLISHED', 'NEW', 'RELATED', 'UNTRACKED'], 'state'),

    # Matches a packet based on its state in the firewall stateful inspection
    # table, using the conntrack module. Values can be:
    # 
    # * INVALID
    # * ESTABLISHED
    # * NEW
    # * RELATED
    # * UNTRACKED
    # * SNAT
    # * DNAT
    # 
    # Valid values are `INVALID`, `ESTABLISHED`, `NEW`, `RELATED`, `UNTRACKED`, `SNAT`, `DNAT`. 
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Enum['INVALID', 'ESTABLISHED', 'NEW', 'RELATED', 'UNTRACKED', 'SNAT', 'DNAT'], 'ctstate'),

    # The specific layer-4 protocol number to match for this rule using the
    # conntrack module.
    # 
    # Values can match `/^!?\s?\d+$/`.
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Pattern[/^!?\s?\d+$/], 'ctproto'),

    # The original source address using the conntrack module. For example:
    # 
    #     ctorigsrc => '192.168.2.0/24'
    # 
    # You can also negate a mask by putting ! in front. For example:
    # 
    #     ctorigsrc => '! 192.168.2.0/24'
    # 
    # The ctorigsrc can also be an IPv6 address if your provider supports it.
    # 
    # 
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Any, 'ctorigsrc'),

    # The original destination address using the conntrack module. For example:
    # 
    #     ctorigdst => '192.168.2.0/24'
    # 
    # You can also negate a mask by putting ! in front. For example:
    # 
    #     ctorigdst => '! 192.168.2.0/24'
    # 
    # The ctorigdst can also be an IPv6 address if your provider supports it.
    # 
    # 
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Any, 'ctorigdst'),

    # The reply source address using the conntrack module. For example:
    # 
    #     ctreplsrc => '192.168.2.0/24'
    # 
    # You can also negate a mask by putting ! in front. For example:
    # 
    #     ctreplsrc => '! 192.168.2.0/24'
    # 
    # The ctreplsrc can also be an IPv6 address if your provider supports it.
    # 
    # 
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Any, 'ctreplsrc'),

    # The reply destination address using the conntrack module. For example:
    # 
    #     ctrepldst => '192.168.2.0/24'
    # 
    # You can also negate a mask by putting ! in front. For example:
    # 
    #     ctrepldst => '! 192.168.2.0/24'
    # 
    # The ctrepldst can also be an IPv6 address if your provider supports it.
    # 
    # 
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Any, 'ctrepldst'),

    # The original source port to match for this filter using the conntrack module.
    # For example:
    # 
    #     ctorigsrcport => '80'
    # 
    # You can also specify a port range: For example:
    # 
    #     ctorigsrcport => '80:81'
    # 
    # You can also negate a port by putting ! in front. For example:
    # 
    #     ctorigsrcport => '! 80'
    # 
    # Values can match `/^!?\s?\d+$|^!?\s?\d+\:\d+$/`.
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Pattern[/^!?\s?\d+$|^!?\s?\d+\:\d+$/], 'ctorigsrcport'),

    # The original destination port to match for this filter using the conntrack module.
    # For example:
    # 
    #     ctorigdstport => '80'
    # 
    # You can also specify a port range: For example:
    # 
    #     ctorigdstport => '80:81'
    # 
    # You can also negate a port by putting ! in front. For example:
    # 
    #     ctorigdstport => '! 80'
    # 
    # Values can match `/^!?\s?\d+$|^!?\s?\d+\:\d+$/`.
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Pattern[/^!?\s?\d+$|^!?\s?\d+\:\d+$/], 'ctorigdstport'),

    # The reply source port to match for this filter using the conntrack module.
    # For example:
    # 
    #     ctreplsrcport => '80'
    # 
    # You can also specify a port range: For example:
    # 
    #     ctreplsrcport => '80:81'
    # 
    # You can also negate a port by putting ! in front. For example:
    # 
    #     ctreplsrcport => '! 80'
    # 
    # Values can match `/^!?\s?\d+$|^!?\s?\d+\:\d+$/`.
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Pattern[/^!?\s?\d+$|^!?\s?\d+\:\d+$/], 'ctreplsrcport'),

    # The reply destination port to match for this filter using the conntrack module.
    # For example:
    # 
    #     ctrepldstport => '80'
    # 
    # You can also specify a port range: For example:
    # 
    #     ctrepldstport => '80:81'
    # 
    # You can also negate a port by putting ! in front. For example:
    # 
    #     ctrepldstport => '! 80'
    # 
    # Values can match `/^!?\s?\d+$|^!?\s?\d+\:\d+$/`.
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Pattern[/^!?\s?\d+$|^!?\s?\d+\:\d+$/], 'ctrepldstport'),

    # Matches a packet based on its status using the conntrack module. Values can be:
    # 
    # * EXPECTED
    # * SEEN_REPLY
    # * ASSURED
    # * CONFIRMED
    # 
    # Valid values are `NONE`, `EXPECTED`, `SEEN_REPLY`, `ASSURED`, `CONFIRMED`. 
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Enum['NONE', 'EXPECTED', 'SEEN_REPLY', 'ASSURED', 'CONFIRMED'], 'ctstatus'),

    # Matches a packet based on lifetime remaining in seconds or range of values
    # using the conntrack module. For example:
    # 
    #     ctexpire => '100:150'
    # 
    # Values can match `/^!?\s?\d+$|^!?\s?\d+\:\d+$/`.
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Pattern[/^!?\s?\d+$|^!?\s?\d+\:\d+$/], 'ctexpire'),

    # Matches a packet that is flowing in the specified direction using the
    # conntrack module. If this flag is not specified at all, matches packets
    # in both directions. Values can be:
    # 
    # * REPLY
    # * ORIGINAL
    # 
    # Valid values are `REPLY`, `ORIGINAL`. 
    # 
    # Requires features conntrack.
    Puppet::Resource::Param(Enum['REPLY', 'ORIGINAL'], 'ctdir'),

    # Match the Netfilter mark value associated with the packet.  Accepts either of:
    # mark/mask or mark.  These will be converted to hex if they are not already.
    # 
    # 
    # 
    # Requires features mark.
    Puppet::Resource::Param(Any, 'connmark'),

    # Connection limiting value for matched connections above n.
    # 
    # Values can match `/^\d+$/`.
    # 
    # Requires features connection_limiting.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'connlimit_above'),

    # Connection limiting by subnet mask for matched connections.
    # IPv4: 0-32
    # IPv6: 0-128
    # 
    # Values can match `/^\d+$/`.
    # 
    # Requires features connection_limiting.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'connlimit_mask'),

    # Hop limiting value for matched packets.
    # 
    # Values can match `/^\d+$/`.
    # 
    # Requires features hop_limiting.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'hop_limit'),

    # Rate limiting value for matched packets. The format is:
    # rate/[/second/|/minute|/hour|/day].
    # 
    # Example values are: '50/sec', '40/min', '30/hour', '10/day'."
    # 
    # 
    # 
    # Requires features rate_limiting.
    Puppet::Resource::Param(Any, 'limit'),

    # Rate limiting burst value (per second) before limit checks apply.
    # 
    # Values can match `/^\d+$/`.
    # 
    # Requires features rate_limiting.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'burst'),

    # UID or Username owner matching rule.  Accepts a string argument
    # only, as iptables does not accept multiple uid in a single
    # statement.
    # 
    # 
    # 
    # Requires features owner.
    Puppet::Resource::Param(Any, 'uid'),

    # GID or Group owner matching rule.  Accepts a string argument
    # only, as iptables does not accept multiple gid in a single
    # statement.
    # 
    # 
    # 
    # Requires features owner.
    Puppet::Resource::Param(Any, 'gid'),

    # Match the Netfilter mark value associated with the packet.  Accepts either of:
    # mark/mask or mark.  These will be converted to hex if they are not already.
    # 
    # 
    # 
    # Requires features mark.
    Puppet::Resource::Param(Any, 'match_mark'),

    # Set the Netfilter mark value associated with the packet.  Accepts either of:
    # mark/mask or mark.  These will be converted to hex if they are not already.
    # 
    # 
    # 
    # Requires features mark.
    Puppet::Resource::Param(Any, 'set_mark'),

    # Sets the clamp mss to pmtu flag.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'clamp_mss_to_pmtu'),

    # Set DSCP Markings.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'set_dscp'),

    # This sets the DSCP field according to a predefined DiffServ class.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'set_dscp_class'),

    # Sets the TCP MSS value for packets.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'set_mss'),

    # Sets the packet type to match.
    # 
    # Valid values are `unicast`, `broadcast`, `multicast`. 
    # 
    # Requires features pkttype.
    Puppet::Resource::Param(Enum['unicast', 'broadcast', 'multicast'], 'pkttype'),

    # Set to true to match tcp fragments (requires type to be set to tcp)
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features isfragment.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'isfragment'),

    # Enable the recent module. Takes as an argument one of set, update,
    # rcheck or remove. For example:
    # 
    #   ```
    #   # If anyone's appeared on the 'badguy' blacklist within
    #   #  the last 60 seconds, drop their traffic, and update the timestamp.
    #   firewall { '100 Drop badguy traffic':
    #     recent   => 'update',
    #     rseconds => 60,
    #     rsource  => true,
    #     rname    => 'badguy',
    #     action   => 'DROP',
    #     chain    => 'FORWARD',
    #   }
    #   ```
    # 
    # 
    #   ```
    #   # No-one should be sending us traffic on eth0 from the
    #   #  localhost, Blacklist them
    #   firewall { '101 blacklist strange traffic':
    #     recent      => 'set',
    #     rsource     => true,
    #     rname       => 'badguy',
    #     destination => '127.0.0.0/8',
    #     iniface     => 'eth0',
    #     action      => 'DROP',
    #     chain       => 'FORWARD',
    #   }
    #   ```
    # 
    # Valid values are `set`, `update`, `rcheck`, `remove`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Enum['set', 'update', 'rcheck', 'remove'], 'recent'),

    # Recent module; add the destination IP address to the list.
    # Must be boolean true.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'rdest'),

    # Recent module; add the source IP address to the list.
    # Must be boolean true.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'rsource'),

    # Recent module; The name of the list. Takes a string argument.
    # 
    # 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Any, 'rname'),

    # Recent module; used in conjunction with one of `recent => 'rcheck'` or
    # `recent => 'update'`. When used, this will narrow the match to only
    # happen when the address is in the list and was seen within the last given
    # number of seconds.
    # 
    # 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Any, 'rseconds'),

    # Recent module; can only be used in conjunction with the `rseconds`
    # attribute. When used, this will cause entries older than 'seconds' to be
    # purged.  Must be boolean true.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'reap'),

    # Recent module; used in conjunction with `recent => 'update'` or `recent
    # => 'rcheck'. When used, this will narrow the match to only happen when
    # the address is in the list and packets had been received greater than or
    # equal to the given value.
    # 
    # 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Any, 'rhitcount'),

    # Recent module; may only be used in conjunction with one of `recent =>
    # 'rcheck'` or `recent => 'update'`. When used, this will narrow the match
    # to only happen when the address is in the list and the TTL of the current
    # packet matches that of the packet which hit the `recent => 'set'` rule.
    # This may be useful if you have problems with people faking their source
    # address in order to DoS you via this module by disallowing others access
    # to your site by sending bogus packets to you.  Must be boolean true.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'rttl'),

    # Enable the rpfilter module.
    # 
    # Valid values are `loose`, `validmark`, `accept-local`, `invert`. 
    # 
    # Requires features rpfilter.
    Puppet::Resource::Param(Enum['loose', 'validmark', 'accept-local', 'invert'], 'rpfilter'),

    # If true, matches if an open socket can be found by doing a coket lookup
    # on the packet.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features socket.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'socket'),

    # If true, matches if the packet has it's 'more fragments' bit set. ipv6.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features ishasmorefrags.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'ishasmorefrags'),

    # If true, matches if the packet is the last fragment. ipv6.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features islastfrag.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'islastfrag'),

    # If true, matches if the packet is the first fragment.
    # Sadly cannot be negated. ipv6.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features isfirstfrag.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'isfirstfrag'),

    # Sets the ipsec policy type. May take a combination of arguments for any flags that can be passed to `--pol ipsec` such as: `--strict`, `--reqid 100`, `--next`, `--proto esp`, etc.
    # 
    # Valid values are `none`, `ipsec`. 
    # 
    # Requires features ipsec_policy.
    Puppet::Resource::Param(Enum['none', 'ipsec'], 'ipsec_policy'),

    # Sets the ipsec policy direction
    # 
    # Valid values are `in`, `out`. 
    # 
    # Requires features ipsec_dir.
    Puppet::Resource::Param(Enum['in', 'out'], 'ipsec_dir'),

    # Set the matching mode for statistic matching.
    # 
    # Valid values are `nth`, `random`.
    Puppet::Resource::Param(Enum['nth', 'random'], 'stat_mode'),

    # Match one packet every nth packet. Requires `stat_mode => 'nth'`
    Puppet::Resource::Param(Any, 'stat_every'),

    # Set the initial counter value for the nth mode. Must be between 0 and the value of `stat_every`. Defaults to 0. Requires `stat_mode => 'nth'`
    # 
    # Values can match `/^\d+$/`.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'stat_packet'),

    # Set the probability from 0 to 1 for a packet to be randomly matched. It works only with `stat_mode => 'random'`.
    Puppet::Resource::Param(Any, 'stat_probability'),

    # Sets the mask to use when `recent` is enabled.
    # 
    # 
    # 
    # Requires features mask.
    Puppet::Resource::Param(Any, 'mask'),

    # The TEE target will clone a packet and redirect this clone to another
    # machine on the local network segment. gateway is the target host's IP.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'gateway'),

    # Matches against the specified ipset list.
    # Requires ipset kernel module. Will accept a single element or an array.
    # The value is the name of the blacklist, followed by a space, and then
    # 'src' and/or 'dst' separated by a comma.
    # For example: 'blacklist src,dst'
    # 
    # 
    # 
    # Requires features ipset.
    Puppet::Resource::Param(Any, 'ipset'),

    # Compute and fill missing packet checksums.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'checksum_fill'),

    # MAC Source
    # 
    # Values can match `/^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$/i`.
    Puppet::Resource::Param(Pattern[/(?i-mx:^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$)/], 'mac_source'),

    # Match if the packet is entering a bridge from the given interface.
    # 
    # Values can match `/^[a-zA-Z0-9\-\._\+]+$/`.
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Pattern[/^[a-zA-Z0-9\-\._\+]+$/], 'physdev_in'),

    # Match if the packet is leaving a bridge via the given interface.
    # 
    # Values can match `/^[a-zA-Z0-9\-\._\+]+$/`.
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Pattern[/^[a-zA-Z0-9\-\._\+]+$/], 'physdev_out'),

    # Match if the packet is transversing a bridge.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'physdev_is_bridged'),

    # Matches if the packet has entered through a bridge interface.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'physdev_is_in'),

    # Matches if the packet will leave through a bridge interface.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'physdev_is_out'),

    # Only match during the given time, which must be in ISO 8601 "T" notation.
    # The possible time range is 1970-01-01T00:00:00 to 2038-01-19T04:17:07
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'date_start'),

    # Only match during the given time, which must be in ISO 8601 "T" notation.
    # The possible time range is 1970-01-01T00:00:00 to 2038-01-19T04:17:07
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'date_stop'),

    # Only match during the given daytime. The possible time range is 00:00:00 to 23:59:59.
    # Leading zeroes are allowed (e.g. "06:03") and correctly interpreted as base-10.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'time_start'),

    # Only match during the given daytime. The possible time range is 00:00:00 to 23:59:59.
    # Leading zeroes are allowed (e.g. "06:03") and correctly interpreted as base-10.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'time_stop'),

    # Only match on the given days of the month. Possible values are 1 to 31.
    # Note that specifying 31 will of course not match on months which do not have a 31st day;
    # the same goes for 28- or 29-day February.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'month_days'),

    # Only match on the given weekdays.
    # 
    # Valid values are `Mon`, `Tue`, `Wed`, `Thu`, `Fri`, `Sat`, `Sun`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Enum['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], 'week_days'),

    # When time_stop is smaller than time_start value, match this as a single time period instead distinct intervals.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'time_contiguous'),

    # Use the kernel timezone instead of UTC to determine whether a packet meets the time regulations.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'kernel_timezone'),

    # Used with the CLUSTERIP jump target.
    # Create a new ClusterIP. You always have to set this on the first rule for a given ClusterIP.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'clusterip_new'),

    # Used with the CLUSTERIP jump target.
    # Specify the hashing mode.
    # 
    # Valid values are `sourceip`, `sourceip-sourceport`, `sourceip-sourceport-destport`. 
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Enum['sourceip', 'sourceip-sourceport', 'sourceip-sourceport-destport'], 'clusterip_hashmode'),

    # Used with the CLUSTERIP jump target.
    # Specify the ClusterIP MAC address. Has to be a link-layer multicast address.
    # 
    # Values can match `/^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$/i`.
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Pattern[/(?i-mx:^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$)/], 'clusterip_clustermac'),

    # Used with the CLUSTERIP jump target.
    # Number of total nodes within this cluster.
    # 
    # Values can match `/\d+/`.
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Pattern[/\d+/], 'clusterip_total_nodes'),

    # Used with the CLUSTERIP jump target.
    # Specify the random seed used for hash initialization.
    # 
    # Values can match `/\d+/`.
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Pattern[/\d+/], 'clusterip_local_node'),

    # Used with the CLUSTERIP jump target.
    # Specify the random seed used for hash initialization.
    # 
    # 
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Any, 'clusterip_hash_init'),

    # Sets the length of layer-3 payload to match.
    # 
    # 
    # 
    # Requires features length.
    Puppet::Resource::Param(Any, 'length'),

    # String matching feature. Matches the packet against the pattern
    # given as an argument.
    # 
    # 
    # 
    # Requires features string_matching.
    Puppet::Resource::Param(Any, 'string'),

    # String matching feature. Matches the package against the hex pattern
    # given as an argument.
    Puppet::Resource::Param(Any, 'string_hex'),

    # String matching feature, pattern matching strategy.
    # 
    # Valid values are `bm`, `kmp`. 
    # 
    # Requires features string_matching.
    Puppet::Resource::Param(Enum['bm', 'kmp'], 'string_algo'),

    # String matching feature, offset from which we start looking for any matching.
    # 
    # 
    # 
    # Requires features string_matching.
    Puppet::Resource::Param(Any, 'string_from'),

    # String matching feature, offset up to which we should scan.
    # 
    # 
    # 
    # Requires features string_matching.
    Puppet::Resource::Param(Any, 'string_to'),

    # Used with NFQUEUE jump target.
    # What queue number to send packets to
    # 
    # 
    # 
    # Requires features queue_num.
    Puppet::Resource::Param(Any, 'queue_num'),

    # Used with NFQUEUE jump target
    # Allow packets to bypass :queue_num if userspace process is not listening
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features queue_bypass.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'queue_bypass'),

    # src attribute for the module geoip
    # 
    # Values can match `/^[A-Z]{2}(,[A-Z]{2})*$/`.
    Puppet::Resource::Param(Pattern[/^[A-Z]{2}(,[A-Z]{2})*$/], 'src_cc'),

    # dst attribute for the module geoip
    # 
    # Values can match `/^[A-Z]{2}(,[A-Z]{2})*$/`.
    Puppet::Resource::Param(Pattern[/^[A-Z]{2}(,[A-Z]{2})*$/], 'dst_cc'),

    # The name for the /proc/net/ipt_hashlimit/foo entry.
    # This parameter is required.
    Puppet::Resource::Param(Any, 'hashlimit_name'),

    # Match if the rate is below or equal to amount/quantum. It is specified either as a number, with an optional time quantum suffix (the default is 3/hour), or as amountb/second (number of bytes per second).
    # This parameter or hashlimit_above is required.
    # Allowed forms are '40','40/second','40/minute','40/hour','40/day'.
    Puppet::Resource::Param(Any, 'hashlimit_upto'),

    # Match if the rate is above amount/quantum.
    # This parameter or hashlimit_upto is required.
    # Allowed forms are '40','40/second','40/minute','40/hour','40/day'.
    Puppet::Resource::Param(Any, 'hashlimit_above'),

    # Maximum initial number of packets to match: this number gets recharged by one every time the limit specified above is not reached, up to this number; the default is 5. When byte-based rate matching is requested, this option specifies the amount of bytes that can exceed the given rate. This option should be used with caution -- if the entry expires, the burst value is reset too.
    # 
    # Values can match `/^\d+$/`.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'hashlimit_burst'),

    # A comma-separated list of objects to take into consideration. If no --hashlimit-mode option is given, hashlimit acts like limit, but at the expensive of doing the hash housekeeping.
    # Allowed values are: srcip, srcport, dstip, dstport
    Puppet::Resource::Param(Any, 'hashlimit_mode'),

    # When --hashlimit-mode srcip is used, all source addresses encountered will be grouped according to the given prefix length and the so-created subnet will be subject to hashlimit. prefix must be between (inclusive) 0 and 32. Note that --hashlimit-srcmask 0 is basically doing the same thing as not specifying srcip for --hashlimit-mode, but is technically more expensive.
    Puppet::Resource::Param(Any, 'hashlimit_srcmask'),

    # Like --hashlimit-srcmask, but for destination addresses.
    Puppet::Resource::Param(Any, 'hashlimit_dstmask'),

    # The number of buckets of the hash table
    Puppet::Resource::Param(Any, 'hashlimit_htable_size'),

    # Maximum entries in the hash.
    Puppet::Resource::Param(Any, 'hashlimit_htable_max'),

    # After how many milliseconds do hash entries expire.
    Puppet::Resource::Param(Any, 'hashlimit_htable_expire'),

    # How many milliseconds between garbage collection intervals.
    Puppet::Resource::Param(Any, 'hashlimit_htable_gcinterval'),

    # Match using Linux Socket Filter. Expects a BPF program in decimal format.
    # This is the format generated by the nfbpf_compile utility.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'bytecode'),

    # Indicates that the current packet belongs to an IPVS connection.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features ipvs.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'ipvs'),

    # Assign this packet to zone id and only have lookups done in that zone.
    # 
    # 
    # 
    # Requires features ct_target.
    Puppet::Resource::Param(Any, 'zone'),

    # Invoke the nf_conntrack_xxx helper module for this packet.
    # 
    # 
    # 
    # Requires features ct_target.
    Puppet::Resource::Param(Any, 'helper'),

    # Matches against the net_cls cgroup ID of the packet.
    Puppet::Resource::Param(Any, 'cgroup')
  ],
  [
    # The canonical name of the rule. This name is also used for ordering
    # so make sure you prefix the rule with a number:
    # 
    #     000 this runs first
    #     999 this runs last
    # 
    # Depending on the provider, the name of the rule can be stored using
    # the comment feature of the underlying firewall subsystem.
    # 
    # Values can match `/^\d+[[:graph:][:space:]]+$/`.
    Puppet::Resource::Param(Pattern[/^\d+[[:graph:][:space:]]+$/], 'name', true),

    # Read-only property for caching the rule line.
    Puppet::Resource::Param(Any, 'line'),

    # The specific backend to use for this `firewall`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ip6tables
    # : Ip6tables type provider
    # 
    #   * Required binaries: `ip6tables-save`, `ip6tables`.
    #   * Supported features: `address_type`, `connection_limiting`, `conntrack`, `ct_target`, `dnat`, `hop_limiting`, `icmp_match`, `interface_match`, `iprange`, `ipsec_dir`, `ipsec_policy`, `ipset`, `iptables`, `isfirstfrag`, `ishasmorefrags`, `islastfrag`, `length`, `log_ip_options`, `log_level`, `log_prefix`, `log_tcp_options`, `log_tcp_sequence`, `log_uid`, `mark`, `mask`, `mss`, `owner`, `pkttype`, `queue_bypass`, `queue_num`, `rate_limiting`, `recent_limiting`, `reject_type`, `snat`, `socket`, `state_match`, `string_matching`, `tcp_flags`.
    # 
    # iptables
    # : Iptables type provider
    # 
    #   * Required binaries: `iptables-save`, `iptables`.
    #   * Default for `kernel` == `linux`.
    #   * Supported features: `address_type`, `clusterip`, `connection_limiting`, `conntrack`, `ct_target`, `dnat`, `icmp_match`, `interface_match`, `iprange`, `ipsec_dir`, `ipsec_policy`, `ipset`, `iptables`, `ipvs`, `isfragment`, `length`, `log_ip_options`, `log_level`, `log_prefix`, `log_tcp_options`, `log_tcp_sequence`, `log_uid`, `mark`, `mask`, `mss`, `netmap`, `nflog_group`, `nflog_prefix`, `nflog_range`, `nflog_threshold`, `owner`, `pkttype`, `queue_bypass`, `queue_num`, `rate_limiting`, `recent_limiting`, `reject_type`, `snat`, `socket`, `state_match`, `string_matching`, `tcp_flags`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
