package main

import "testing"

func Test_myfunc(t *testing.T) {
	tests := []struct {
		name string
	}{
		{
			name: "testing debugger",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			myfunc()
		})
	}
}
