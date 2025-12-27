import { use, query } from "./src/run.ts"
import { assertSnapshot } from "https://esm.sh/jsr/@std/testing@1.0.16/snapshot"

use("romanize.pl")

Deno.test("snapshot", async t => {
    await query(`
        phrase(sentence(_, IR), "A butterfly saw a flower"),
        phrase(sentence(_, IR), Res).
    `, a => assertSnapshot(t, a))
    await query(`
        phrase(sentence(_, IR), "빨간 나비가 아름다운 꽃을 보았다"),
        phrase(sentence(_, IR), Res).
    `, a => assertSnapshot(t, a))
    await query(`
        assertz((
            get_next_word(Prefix, W) :-
                phrase(sentence(ko, _), Full, []),
                append(Prefix, Rest, Full),
                ( append(WL, [' '|_], Rest) -> true ; WL = Rest ),
                atom_chars(W, WL)
        )),
        get_next_word("빨간 나비가 ", W).
    `, a => assertSnapshot(t, a))
})
