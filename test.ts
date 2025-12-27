import { use, query } from "./src/run.ts"
import { assertSnapshot } from "https://esm.sh/jsr/@std/testing@1.0.16/snapshot"

use("romanize.pl")

Deno.test("snapshot", async t => {
    await query(`
        phrase(sentence(_, IR), "A butterfly saw a flower"),
        phrase(sentence(_, IR), Res).
    `, a => assertSnapshot(t, a))
    await query(`
        phrase(sentence(_, IR), "꽃이 나비를 보았다"),
        phrase(sentence(_, IR), Res).
    `, a => assertSnapshot(t, a))
})
