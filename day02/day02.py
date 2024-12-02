def is_safe(report: list[int]) -> bool:
    last = None
    increasing = None

    for reading in report:
        if last is None:
            last = reading
            continue
    
        # must monotonically increase or decrease
        if increasing is None:
            increasing = reading > last
        elif increasing and reading < last:
            return False
        elif not increasing and reading > last:
            return False

        # must be a difference between 1 and 3 inclusive
        diff = abs(reading - last)
        if diff < 1 or diff > 3:
            return False
        
        last = reading
    return True

with open("input.txt") as f:
    lines = f.readlines()
    reports = [[int(x) for x in line.split(" ")] for line in lines]

    # part 1
    safe_reports = list(filter(is_safe, reports))
    print(f"part 1: {len(safe_reports)}")

    # part 2
    safe_dampened_reports = []
    for report in reports:
        if is_safe(report):
            safe_dampened_reports.append(report)
            continue
    
        # see if report can be made safe by removing a reading
        for i in range(len(report)):
            new_report = report[:i] + report[i+1:]
            if is_safe(new_report):
                safe_dampened_reports.append(new_report)
                break
    
    print(f"part 2: {len(safe_dampened_reports)}")
