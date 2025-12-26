import { load, Prolog } from "./deps.ts"

await load()

export const run =
(consult: string) =>
async function* (query: string) {
    const pl = new Prolog()

    await pl.consultText(consult)

    yield* pl.query(query)
}
