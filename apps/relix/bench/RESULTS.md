# Recipe Store perfomance result

Execute on 
- CPU: 11th Gen Intel® Core™ i7-1165G7 @ 2.80GHz × 8
- RAM: 32 GB.
- OS: Ubuntu 20.04.4 LTS

## Test with 1000 concurrent processes

### InMemoryStore:
- average put 8085.814 μs (8 ms)
- average get 41.25 μs (0.4 ms)

### EtsStore:
- average put 5478.601 μs (5ms)
- average get 0.061 μs (0.00006 ms)

### PostgresStore:
- average put 127414.858 μs (127 ms)
- average get 92594.201 μs (92 ms)

## Test with 100_000 concurrent processes

### InMemoryStore:
- average put 4582.26746 μs (4 ms)
- average get 259.54952 μs (0.2 ms)

### EtsStore:
- average put 300.601 μs (0.3 ms)
- average get 0.17 μs (0.0002 ms)

PostgresStore:
Pool size 100. Can't increase or we get a too many connections to postgres

(DBConnection.ConnectionError) connection not available and request was dropped from queue after 1548ms. This means requests are coming in and your connection pool cannot serve them fast enough. 

## Test with 1_000_000 concurrent processes

### InMemoryStore:
- average put 61627.234867 μs (61 ms)
- average get 10669.876854 μs (10 ms)

Single agent bottleneck!

### EtsStore:
- average put 28.601 μs (0.03 ms)
- average get 0.22 μs (0.0002 ms)

