#!/usr/bin/env python
import erlang, os, struct

def send(term, stream):
    """Write an Erlang term to an output stream."""
    payload = erlang.term_to_binary(term)
    header = struct.pack('!I', len(payload))
    stream.write(header)
    stream.write(payload)
    stream.flush()

def recv(stream):
    """Read an Erlang term from an input stream."""
    header = stream.read(4)
    if len(header) != 4:
        return None # EOF
    (length,) = struct.unpack('!I', header)
    payload = stream.read(length)
    if len(payload) != length:
        return None
    term = erlang.binary_to_term(payload)
    return term

def recv_loop(stream):
    """Yield Erlang terms from an input stream."""
    message = recv(stream)
    while message:
        yield message
        message = recv(stream)

if __name__ == '__main__':
    input, output = os.fdopen(3, 'rb'), os.fdopen(4, 'wb')
    for message in recv_loop(input):
        send(message, output) # echo the message back
