package main

import (
	"encoding/json"
	"fmt"
	"time"
)

type Metric struct {
	Time  time.Time              `json:"time" description:""`
	IP    string                 `json:"ip" description:""`
	Name  string                 `json:"name" description:""`
	Tags  map[string]interface{} `json:"tags" description:""`
	Value float64                `json:"value" description:""`
}

func (m Metric) String() string {
	tags, _ := json.Marshal(m.Tags)
	return fmt.Sprintf("%s %s %s '%s' %v", m.Time.Format(time.RFC3339), m.IP, m.Name, string(tags), m.Value)
}

func main() {
	samples := []Metric{{time.Now(), "1.1.1.1", "demo", map[string]interface{}{"region": "us-east-1"}, 2}}

	for _, v := range samples {
		fmt.Println(v.String())
	}
}

// output:
// 2022-05-30T14:40:19+08:00 1.1.1.1 demo '{"region":"us-east-1"}' 2
