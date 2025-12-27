import { use, run, show } from "./src/run.ts"

use("romanize.pl")

const query =
async (query: string) => {

    const res = run(await Deno.readTextFile("sketch/main.pl"))(query)
    console.log(`?- ${query}`)

    for await (const answer of res) {
        console.log(
            show(answer)
        )
    }    
}

await query(`
    phrase(sentence(_, IR), "A butterfly saw a flower"),
    phrase(sentence(_, IR), Res).
`)
