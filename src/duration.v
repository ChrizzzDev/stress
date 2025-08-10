module main

import time

pub fn parse_duration(s string) !time.Duration {
	mut total := time.Duration(0)
	mut num_str := ''
	mut unit_str := ''
	mut i := 0

	for i < s.len {
		ch := s[i].ascii_str()
		if ch[0].is_digit() {
			num_str += ch
		} else {
			unit_str += ch
			next_is_digit := i + 1 < s.len && s[i+1].ascii_str()[0].is_digit()
			if next_is_digit || i + 1 == s.len {
				if num_str == '' {
					return error('Invalid duration format: missing number before unit "${unit_str}"')
				}
				num := num_str.int()
				match unit_str {
					'ms' { total += time.Duration(num) * time.millisecond }
					's' { total += time.Duration(num) * time.second }
					'm' { total += time.Duration(num) * time.minute }
					'h' { total += time.Duration(num) * time.hour }
					else { return error('Invalid duration unit: ${unit_str}') }
				}
				num_str = ''
				unit_str = ''
			}
		}
		i++
	}

	if total <= 0 {
		return error('Invalid duration value: must be greater than zero')
	}
	return total
}