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
        phrase(sentence(ko, _), Full, []), append("빨간 나비가 ", Rest, Full).
    `, a => assertSnapshot(t, a))
})
