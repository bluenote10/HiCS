import os, threadpool

proc spawnBackgroundJob[T](f: iterator (): int): TChannel[T] =

  type Args = tuple[iter: iterator (): T, channel: ptr TChannel[T]]
  #type Args = tuple
  #  iter: iterator (): T
  #  channel: ptr TChannel[T]

  proc threadFunc(args: Args) {.thread.} =

    echo "Thread is starting"
    let iter = args.iter
    var channel = args.channel[]

    for i in iter():
      echo "Sending ", i
      channel.send(i)

  var thread: TThread[Args]
  var channel: TChannel[T]
  channel.open()
  echo "Channel is ready? ", channel.ready()
  
  echo repr(channel)
  echo repr(addr(channel))
  
  let args = (f, channel.addr)
  
  createThread(thread, threadFunc, args)

  echo "Thread has started"
  result = channel


iterator test(): int {.closure.} =
  sleep(500)
  yield 1
  sleep(500)
  yield 2

var channel = spawnBackgroundJob[int](test)

echo "Channel is ready? ", channel.ready()

#echo "Trying to receive..."
#var x = channel.recv()
#echo "Received: ", x

for i in 0 .. 10:
  sleep(200)
  echo channel.peek()

#sleep(2000)
echo "Finished"

