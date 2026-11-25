package core

import (
	"reflect"
	"testing"
)

func TestPrioritizeRequestLanInterface(t *testing.T) {
	tests := []struct {
		name    string
		ifaces  []netInterfaceInfo
		reqHost string
		envLan  string
		want    []netInterfaceInfo
	}{
		{
			name: "TUN active with LAN IP at index 1 keeps TUN first",
			ifaces: []netInterfaceInfo{
				{Name: "FlClash", Addresses: []string{"198.18.0.1"}, IsTun: true},
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
				{Name: "eth1", Addresses: []string{"172.22.0.99"}},
			},
			reqHost: "192.168.5.66:80",
			want: []netInterfaceInfo{
				{Name: "FlClash", Addresses: []string{"198.18.0.1"}, IsTun: true},
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
				{Name: "eth1", Addresses: []string{"172.22.0.99"}},
			},
		},
		{
			name: "TUN active moves LAN IP from index 2 to right after TUN",
			ifaces: []netInterfaceInfo{
				{Name: "FlClash", Addresses: []string{"198.18.0.1"}, IsTun: true},
				{Name: "eth1", Addresses: []string{"172.22.0.99"}},
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
			},
			reqHost: "192.168.5.66",
			want: []netInterfaceInfo{
				{Name: "FlClash", Addresses: []string{"198.18.0.1"}, IsTun: true},
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
				{Name: "eth1", Addresses: []string{"172.22.0.99"}},
			},
		},
		{
			name: "TUN active inserts missing request LAN IP after TUN",
			ifaces: []netInterfaceInfo{
				{Name: "FlClash", Addresses: []string{"198.18.0.1"}, IsTun: true},
				{Name: "eth0", Addresses: []string{"172.17.0.2"}},
			},
			reqHost: "192.168.5.66",
			want: []netInterfaceInfo{
				{Name: "FlClash", Addresses: []string{"198.18.0.1"}, IsTun: true},
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
				{Name: "eth0", Addresses: []string{"172.17.0.2"}},
			},
		},
		{
			name: "custom named TUN stays at index 0",
			ifaces: []netInterfaceInfo{
				{Name: "customtun0", Addresses: []string{"28.0.0.1"}, IsTun: true},
				{Name: "eth0", Addresses: []string{"172.17.0.2"}},
			},
			reqHost: "192.168.5.66",
			want: []netInterfaceInfo{
				{Name: "customtun0", Addresses: []string{"28.0.0.1"}, IsTun: true},
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
				{Name: "eth0", Addresses: []string{"172.17.0.2"}},
			},
		},
		{
			name: "reqHost matching TUN IP does not duplicate or demote TUN",
			ifaces: []netInterfaceInfo{
				{Name: "FlClash", Addresses: []string{"198.18.0.1"}, IsTun: true},
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
			},
			reqHost: "198.18.0.1",
			want: []netInterfaceInfo{
				{Name: "FlClash", Addresses: []string{"198.18.0.1"}, IsTun: true},
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
			},
		},
		{
			name: "TUN inactive moves request LAN IP to index 0",
			ifaces: []netInterfaceInfo{
				{Name: "eth1", Addresses: []string{"172.22.0.99"}},
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
			},
			reqHost: "192.168.5.66",
			want: []netInterfaceInfo{
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
				{Name: "eth1", Addresses: []string{"172.22.0.99"}},
			},
		},
		{
			name: "TUN inactive inserts FLCLASH_LAN_IP at index 0",
			ifaces: []netInterfaceInfo{
				{Name: "eth0", Addresses: []string{"172.17.0.2"}},
			},
			envLan: "192.168.5.66",
			want: []netInterfaceInfo{
				{Name: "eth0", Addresses: []string{"192.168.5.66"}},
				{Name: "eth0", Addresses: []string{"172.17.0.2"}},
			},
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			orig := append([]netInterfaceInfo(nil), tc.ifaces...)
			got := prioritizeRequestLanInterface(tc.ifaces, tc.reqHost, tc.envLan)
			if !reflect.DeepEqual(got, tc.want) {
				t.Fatalf("prioritizeRequestLanInterface() = %+v, want %+v", got, tc.want)
			}
			if !reflect.DeepEqual(tc.ifaces, orig) {
				t.Fatalf("input slice mutated: got %+v, want %+v", tc.ifaces, orig)
			}
		})
	}
}
