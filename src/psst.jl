module psst

# For clipboard read
using InteractiveUtils
using Base64
using SHA
using Base

#-----------------------------------------------------------------------
# Composable map and filter
##-----------------------------------------------------------------------

#Allows composing pipelines with map
#foo |> map(uppercase)
#foo |> map(x->lowercase)
Base.map(f) = function(data...) map(f, data...) end

#Allows composing pipelines with filter
#foo |> filter(isascii)
Base.filter(f) = function(data...) filter(f, data...) end

#-----------------------------------------------------------------------
# Start extra functions
#-----------------------------------------------------------------------

# Encodings
sha256(s::AbstractString) = SHA.sha256(s) |> bytes2hex
base64(s::AbstractString) = Base64.base64encode(s)

# String transforms
words(s::AbstractString) = split(s, " ")
escape(s::AbstractString) = escape_string(s)
unescape(s::AbstractString) = unescape_string(s)

# "hello world" -> "hElLo wOrLd". Picks random starting case.
spongebob(s::AbstractString) = (c = Bool(rand(Bool, 1)[1]); map(x-> begin c = !c; (c == true ? uppercase(x) : lowercase(x)) end, s))

# Search / Matching
Base.match(r::Regex) = x -> map(String, match(r, x).captures)

#-----------------------------------------------------------------------
# End extra functions
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Pretty print for types
#-----------------------------------------------------------------------

# SubString arrays, should print as: "first", "second", "third"
Base.show(io::IO, str::Array{SubString{String}}) = join(map(x->"\"$x\"", str), ", ") |> println

#-----------------------------------------------------------------------
# End pretty print for types
#-----------------------------------------------------------------------

function parseall(input, str)
  return Meta.parse("begin \"$(escape_string(input))\" |> $str |> println end").args
end

function julia_main()::Cint
  # Check if we need to read from stdin or clipboard.
  istty = isa(stdin, Base.TTY)

  # Slurp all input
  input = istty ? clipboard() : readchomp(stdin)

  # Only accept one parameter for now, revise this later.
  if length(ARGS) != 1
    println("psst only supports one argument right now")
    exit(1)
  end

  # Just prepending the pipeline from input here, make more robust later.
  cmd_str = ARGS[1]
  exprs = parseall(input, cmd_str)
  #println("Exprs: $(exprs)")
  for expr in exprs; Core.eval(psst, expr);  end
  return 0 # if things finished successfully
end
julia_main()

end # module