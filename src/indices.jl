linear_index(n, grade) = sum(binomial.(n, 0:(grade-1)))

function linear_index(n, grade, indices)
    linear_index(n, grade) + grade_index(n, indices)
end

function grade_from_linear_index(n, index)
    grade_end = 1
    for g ∈ 0:n
        if grade_end >= index
            return (g, grade_end)
        else
            grade_end += binomial(n, g+1)
        end
    end
    if grade_end >= index
        (n, grade_end)
    else
        error("Could not fetch linear index from $index with dimension $n")
    end
end

function indices_from_linear_index(n, index)
    grade, grade_end = grade_from_linear_index(n, index)
    grade_start = grade_end - binomial(n, grade)
    grade == 0 && return SVector{0,Int}()
    cs = collect(combinations(1:n, grade))
    SVector{grade}(cs[index - grade_start])
end

"""
    grade_index(dim, i)

Return the grade index of `i`.

## Example
```julia
julia> grade_index(3, [1])
1

julia> grade_index(3, [3, 1])
3
```
"""
function grade_index(n, i)
    grade = length(i)
    if grade == 0
        1
    elseif grade == 1
        first(i)
    elseif first(i) == 1
        grade_index(n - 1, i[2:end] .- 1)
    else
        grade_index(n - 1, i .- 1) + (n - 1)
    end
end
