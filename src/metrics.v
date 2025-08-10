module main

import time
import arrays

pub fn metrics(cfg Config, results []Result) ! {
	successes := results.filter(it.success)
	fails := results.len - successes.len
	avg_latency := if successes.len > 0 {
		l := results.filter(it.success).map(it.latency)
		arrays.reduce(l, fn(acc time.Duration, val time.Duration) f64 {
			return acc + val.nanoseconds()
		}) or { 0.0 } / f64(successes.len)
	} else { 0.0 }

	latencies := successes.map(it.latency)
	p50 := calculate_percentile(latencies, 50)
	p95 := calculate_percentile(latencies, 95)
	p99 := calculate_percentile(latencies, 99)

	duraion_sec := cfg.duration.seconds()
	throughput := f64(successes.len) / duraion_sec
	
	header := '='.repeat(15) + ' Stress Test Results ' + '='.repeat(15)

	n := 1e6
	println(header)
	println('Total requests: ${results.len}')
	println('Successful: ${successes.len} | Failed: ${fails}')
	println('Throughput: ${throughput:.2f} req/s')
	println('Average latency: ${(avg_latency / n):.2} | min: ${(arrays.min(latencies)! / n):.2} | max: ${(arrays.max(latencies)! / n):.2}')
	println('p50: ${(p50 / n):.2} | p95: ${(p95 / n):.2} | p99: ${(p99 / n):.2}')
}