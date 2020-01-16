# Pyport

Example project on how to use [`erlang_py`](https://github.com/okeuday/erlang_py)
from Elixir.

## Usage

Install python dependencies

```bash
$ pip install -r requirements.txt
```

```elixir
iex(1)> {:ok, pid} = Pyport.start_link()
{:ok, #PID<0.109.0>}
iex(2)> :ok = Pyport.echo(:hello)
:ok
iex(3)> flush()
:hello
:ok
iex(4)>
```
