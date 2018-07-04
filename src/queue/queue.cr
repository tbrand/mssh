module Mssh
  class Queue
    enum Status
      NotReady
      Enqueued
      Fin
    end

    @@queue : Queue? = nil

    def self.init(parallel : Int32)
      @@queue = Queue.new(parallel)
    end

    def self.global : Queue
      raise "queue is not ready" unless queue = @@queue
      queue
    end

    getter queue   : Array(Executable) = [] of Executable

    @status  : Status = Status::NotReady
    @procs   : Array(Process) = [] of Process

    def initialize(@parallel : Int32)
    end

    def loop
      spawn do
        loop do
          @procs.each do |proc|
            @procs.delete(proc) if proc.terminated?
          end

          if @procs.size < @parallel && @queue.size > 0
            L.verbose "dequeue another job (running: #{@procs.size}, queue size: #{@queue.size})"

            job = @queue.shift

            @procs << Process.fork do
              job.exec
            end
          end

          if @procs.size == 0 && @queue.size == 0 && @status == Status::Enqueued
            L.info "finished every jobs 😎"
            break
          end

          sleep 0.1
        end

        @status = Status::Fin
      end
    end

    def <<(executable : Executable)
      enqueue(executable)
    end

    def enqueue(executable : Executable)
      L.verbose "enqueue new job (running: #{@procs.size}, queue size: #{@queue.size})"
      @queue << executable
    end

    def wait
      @status = Status::Enqueued

      loop do
        sleep 0.1
        break if @status == Status::Fin
      end
    end
  end
end
