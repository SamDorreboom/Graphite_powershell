# Define the Graphite server address and port
$graphiteServer = "192.168.159.1"
$graphitePort = 32776

# Define the metric, value, and timestamp
$metricPath = "test.tcp"
$value = 400
#$epoch = Get-Date "1970-01-01T00:00:00Z"
$timestamp = [int][double]::Parse((Get-Date -UFormat %s))
#$timestamp = 1717674116

# Create the data string
$data = "$metricPath $value $timestamp`n"

# Open a TCP connection to the Graphite server
$tcpClient = New-Object System.Net.Sockets.TcpClient

try {
    $tcpClient.Connect($graphiteServer, $graphitePort)
    if ($tcpClient.Connected) {
        Write-Host "Connected to Graphite server at ${graphiteServer}:${graphitePort}"
        
        # Get the network stream
        $networkStream = $tcpClient.GetStream()

        # Convert the data string to bytes
        $dataBytes = [System.Text.Encoding]::ASCII.GetBytes($data)

        # Write the data to the network stream
        $networkStream.Write($dataBytes, 0, $dataBytes.Length)
        
        Write-Host "Metric sent to Graphite: $data"

        # Close the network stream and TCP connection
        $networkStream.Close()
    } else {
        Write-Host "Failed to connect to Graphite server at ${graphiteServer}:${graphitePort}"
    }
} catch {
    Write-Host "Exception: $_"
} finally {
    $tcpClient.Close()
}
