import { load, Prolog, Answer } from "./deps/trealla.ts"
import { Toplevel } from "./deps/Toplevel.js"
import { assertEquals } from "https://esm.sh/jsr/@std/assert@1.0.16"

await load()

const imports = [] as string[]

export const use =
(path: string) => {
    imports.push(path)
}

export const run =
(consult: string) =>
async function* (query: string) {
    const pl = new Prolog()

    for await (const entry of imports) {
        // console.log(`import: sketch/${entry}`)
        
        // @ts-expect-error:
        pl.fs.open(`/${entry}`, { write: true, create: true })
            .writeString(await Deno.readTextFile(`sketch/${entry}`))
        
        await pl.consult(`/${entry}`)
    }

    await pl.consultText(consult)

    yield* pl.query(query, { format: new Toplevel() })
}

export const show =
(answer: Answer) =>
    answer.status == "success"
        ? Object.entries(answer.answer)
            .map(([k, v]) => `  ${k} = ${v}`)
            .join("\n")
        : answer.stdout

export const query =
async (query: string, expected?: string) => {
    const res = run(await Deno.readTextFile("sketch/main.pl"))(query)
    console.log(`?- ${query}`)

    const expectedList = expected?.trim()
        .split("\n")
        .map(x => x.trim())

    let i = 0
    for await (const answer of res) {
        const res = show(answer)

        console.log(res)

        if (expected && expectedList?.at(i)) {
            assertEquals(res, expectedList?.at(i))
        }

        i++
    }
}
