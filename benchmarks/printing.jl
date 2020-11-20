
using TerminalLoggers
using REPL
using REPL:Terminals
using Logging: global_logger

global_logger(TerminalLogger())

const log_term = Terminals.TTYTerminal("", stdin, stdout, stderr)

function replprint(output::String;
    newline::Int=0, clearline::Int=1, color::Symbol=:white, bold::Bool=false,
    prefix::String="", prefix_color::Symbol=:green, prefix_bold::Bool=true, indent_level::Int=0)

    # clear line
    if clearline > 0
        for i in 1:(clearline + 1)
            Terminals.clear_line(log_term)
        end
    end

    # indent
    print(" "^indent_level)
    
    # print info
    if !isempty(prefix)
        printstyled(prefix, color=prefix_color, bold=prefix_bold)
    end
    printstyled(output, color=color, bold=bold)

    # print new lines
    [println() for _ ∈ 1:newline]
end
