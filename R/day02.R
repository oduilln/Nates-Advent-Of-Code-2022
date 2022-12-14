#' Day 02: Rock Paper Scissors
#'
#' [Rock Paper Scissors](https://adventofcode.com/2022/day/2)
#'
#' @name day02
#' @rdname day02
#' @details
#'
#' **Part One**
#'
#' The Elves begin to set up camp on the beach. To decide whose tent gets
#' to be closest to the snack storage, a giant [Rock Paper
#' Scissors](https://en.wikipedia.org/wiki/Rock_paper_scissors) tournament
#' is already in progress.
#'
#' Rock Paper Scissors is a game between two players. Each game contains
#' many rounds; in each round, the players each simultaneously choose one
#' of Rock, Paper, or Scissors using a hand shape. Then, a winner for that
#' round is selected: Rock defeats Scissors, Scissors defeats Paper, and
#' Paper defeats Rock. If both players choose the same shape, the round
#' instead ends in a draw.
#'
#' Appreciative of your help yesterday, one Elf gives you an *encrypted
#' strategy guide* (your puzzle input) that they say will be sure to help
#' you win. \"The first column is what your opponent is going to play: `A`
#' for Rock, `B` for Paper, and `C` for Scissors. The second column\--\"
#' Suddenly, the Elf is called away to help with someone\'s tent.
#'
#' The second column, [you reason]{title="Why do you keep guessing?!"},
#' must be what you should play in response: `X` for Rock, `Y` for Paper,
#' and `Z` for Scissors. Winning every time would be suspicious, so the
#' responses must have been carefully chosen.
#'
#' The winner of the whole tournament is the player with the highest score.
#' Your *total score* is the sum of your scores for each round. The score
#' for a single round is the score for the *shape you selected* (1 for
#' Rock, 2 for Paper, and 3 for Scissors) plus the score for the *outcome
#' of the round* (0 if you lost, 3 if the round was a draw, and 6 if you
#' won).
#'
#' Since you can\'t be sure if the Elf is trying to help you or trick you,
#' you should calculate the score you would get if you were to follow the
#' strategy guide.
#'
#' For example, suppose you were given the following strategy guide:
#'
#'     A Y
#'     B X
#'     C Z
#'
#' This strategy guide predicts and recommends the following:
#'
#' -   In the first round, your opponent will choose Rock (`A`), and you
#'     should choose Paper (`Y`). This ends in a win for you with a score
#'     of *8* (2 because you chose Paper + 6 because you won).
#' -   In the second round, your opponent will choose Paper (`B`), and you
#'     should choose Rock (`X`). This ends in a loss for you with a score
#'     of *1* (1 + 0).
#' -   The third round is a draw with both players choosing Scissors,
#'     giving you a score of 3 + 3 = *6*.
#'
#' In this example, if you were to follow the strategy guide, you would get
#' a total score of `15` (8 + 1 + 6).
#'
#' *What would your total score be if everything goes exactly according to
#' your strategy guide?*
#'
#' **Part Two**
#'
#' *(Use have to manually add this yourself.)*
#'
#' *(Try using `convert_clipboard_html_to_roxygen_md()`)*
#'
#'

#' A: ROCK
#' B: PAPER
#' C: SCISSORS
#'
#' A < B
#' B < C
#' C < A

match_win <- function(opp) {
    case_when(
        opp == "A" ~ "B",
        opp == "B" ~ "C",
        opp == "C" ~ "A"
    )
}

match_loss <- function(opp) {
    case_when(
        opp == "A" ~ "C",
        opp == "B" ~ "A",
        opp == "C" ~ "B"
    )
}



solve <- function(data, sum = TRUE, treat_as_strategy = FALSE) {

    if(treat_as_strategy) {
        data <- data |>
            mutate(
                strategy = hero,
                hero = case_when(
                    strategy == "X" ~ match_loss(villain),
                    strategy == "Y" ~ villain,
                    strategy == "Z" ~ match_win(villain)
                )
            )
    } else {
        data <- data |>
            mutate(hero = case_when(
                hero == "X" ~ "A",
                hero == "Y" ~ "B",
                hero == "Z" ~ "C"
            ))
    }

    data <- data |>
        mutate(
            result_hero = case_when(
                villain == hero ~ 0,
                villain == "A"  ~ if_else(hero == "B", 1, -1),
                villain == "B"  ~ if_else(hero == "C", 1, -1),
                villain == "C"  ~ if_else(hero == "A", 1, -1)
            ),
            result_villain = result_hero * -1,
            bonus_villain = match(villain, LETTERS),
            bonus_hero = match(hero, LETTERS),
            outcome_hero = (result_hero + 1)* 3,
            outcome_villain = (result_villain + 1)* 3,
            hero_score = bonus_hero + outcome_hero,
            villain_score = bonus_villain + outcome_villain
        )

    if(sum) {
        data <- data |>
            summarise(total_hero = sum(hero_score), total_villain = sum(villain_score))
    }

    return(data)
}


#' @param x some data
#' @return For Part One, `f02a(x)` returns .... For Part Two,
#'   `f02b(x)` returns ....
#' @export
#' @examples
#' f02a(example_data_02())
#' f02b()
f02a <- function(x) {
    result <- solve(x, treat_as_strategy = FALSE)
    return(result$total_hero)
}


#' @rdname day02
#' @export
f02b <- function(x) {
    result <- solve(x, treat_as_strategy = TRUE)
    return(result$total_hero)
}


f02_helper <- function(x) {
    readr::read_delim(x, delim = " ", col_names = c("villain", "hero"))
}


#' @param example Which example data to use (by position or name). Defaults to
#'   1.
#' @rdname day02
#' @export
example_data_02 <- function(example = 1) {
  l <- list(
    a = tibble::tibble(villain = c("A", "B", "C"), hero = c("Y", "X", "Z"))
  )
  l[[example]]
}
