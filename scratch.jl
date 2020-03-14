import Base.|>

import Base
using Base.Iterators

# adjoint(f) = (a...) -> (b...) -> f(a..., b...)
# map'(+)(1:10) |> println

Base.Iterators.take(n)   = x -> collect(take(x, n))

Base.match(r::Regex) = x -> map(String, match(r, x).captures)

# split(c) = x -> Base.split(x, c)

"helloworld1234567" |> match(r"(\s+)") |> first |> println