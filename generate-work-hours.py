#!/usr/bin/env python3

import datetime
import json
import sys

DATE_FORMAT = '%Y-%m-%d'

sys.argv.append(9)

from_date = datetime.datetime.strptime(sys.argv[1], DATE_FORMAT)
to_date = datetime.datetime.strptime(sys.argv[2], DATE_FORMAT)
hours = int(sys.argv[3])

def daterange(start_date, end_date):
    days = (end_date - start_date).days
    for n in range(int(days)):
        yield start_date + datetime.timedelta(days=n)

result = []

for d in daterange(from_date, to_date):
    week_day = d.isoweekday()
    if week_day != 6 and week_day != 7:
        result.append({
            'date': d.strftime(DATE_FORMAT),
            'hours': hours,
        })

print(json.dumps(result, indent=2))