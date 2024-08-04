set ns [new Simulator]
$ns rtproto DV
$ns color 1 Blue
set nf [open sample.nam w]
$ns namtrace-all $nf
set tr [open sample.tr w]
$ns trace-all $tr

proc finish {} {
 global ns nf tr
 $ns flush-trace
 close $nf
 close $tr
 exec nam sample.nam &
 exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n0 10Mb 10ms DropTail
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n3 10Mb 10ms DropTail

#$ns duplex-link-op $n0 $n1 orient Right
#$ns duplex-link-op $n0 $n1 orient down
#$ns duplex-link-op $n0 $n1 orient left
#$ns duplex-link-op $n0 $n1 orient up
#$ns duplex-link-op $n0 $n1 orient right-down
#$ns duplex-link-op $n0 $n1 orient left-down

$ns cost $n0 $n1 1
$ns cost $n1 $n2 4
$ns cost $n2 $n3 1
$ns cost $n3 $n0 1
$ns cost $n0 $n2 2
$ns cost $n1 $n3 1

set tcp [new Agent/TCP]
$tcp set class_ 1
$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

$ns at 1.0 "$ftp start"
$ns rtmodel-at 3.0 down $n1 $n2
$ns rtmodel-at 5.0 up $n1 $n2
$ns at 10 "finish"

$ns run
