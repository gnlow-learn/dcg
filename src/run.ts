import { load, Prolog } from "./deps.ts"

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
        console.log(`import: sketch/${entry}`)
        
        // @ts-expect-error:
        pl.fs.open(`/${entry}`, { write: true, create: true })
            .writeString(await Deno.readTextFile(`sketch/${entry}`))
        
        await pl.consult(`/${entry}`)
    }

    await pl.consultText(consult)

    yield* pl.query(query)
}
