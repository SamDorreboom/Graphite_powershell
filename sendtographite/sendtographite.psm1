# GraphiteModule.psm1

function Send-GraphiteMetric {
    param (
        [string]$GraphiteServer,
        [int]$GraphitePort,
        [string]$MetricPath,
        [int]$Value
    )


    #$currentUtcDate = [DateTime]::UtcNow
    #$timestamp = [Math]::Floor(($currentUtcDate - [datetime]'1970-01-01T00:00:00Z').TotalSeconds)

    # Define the timestamp
    #$timestamp = [int][double]::Parse((Get-Date -UFormat %s))
    $timestamp = -1



    # Create the data string
    $data = "$MetricPath $Value $timestamp`n"

    # Open a TCP connection to the Graphite server
    $tcpClient = New-Object System.Net.Sockets.TcpClient

    try {
        $tcpClient.Connect($GraphiteServer, $GraphitePort)
        if ($tcpClient.Connected) {
            Write-Host "Connected to Graphite server at ${GraphiteServer}:${GraphitePort}"
            
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
            Write-Host "Failed to connect to Graphite server at ${GraphiteServer}:${GraphitePort}"
        }
    } catch {
        Write-Host "Exception: $_"
    } finally {
        $tcpClient.Close()
    }
}
