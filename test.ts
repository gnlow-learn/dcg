import { use, run, show } from "./src/run.ts"

use("romanize.pl")

const query = `
    phrase(en_core(s(decl, active, past, pred(see, agent(butterfly, a), obj(flower, a)))), Ls).
`

const res = run(await Deno.readTextFile("sketch/main.pl"))(query)

for await (const answer of res) {
    console.log(`?- ${query}`)
    console.log(
        show(answer)
    )
}
