module main

import net.http
import time

pub struct Config {
	pub:
		url         string
		concurrency int
		duration    time.Duration
		method			string
		body				string
}

pub fn worker(id int, cfg Config, ch chan Result, stop_at time.Time) {
	for {
		if time.now() >= stop_at { break }
		start := time.now()

		mut resp := http.Response{}
		if cfg.method == 'POST' {
			resp = http.post(cfg.url, cfg.body) or {
				ch <- Result{success: false, latency: 0}
				continue
			}
		} else {
			resp = http.get(cfg.url) or {
				ch <- Result{success: false, latency: 0}
				continue
			}
		}

		latency := time.since(start)
		ch <- Result{success: resp.status_code == 200, latency: latency}
	}
}