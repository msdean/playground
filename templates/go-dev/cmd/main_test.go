package main

import "testing"

func Test_Main(t *testing.T) {
	tests := []struct {
		name string
	}{
		{
			name: "testing main",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			main()
		})
	}
}
