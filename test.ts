import { run } from "./src/run.ts"

await Array.fromAsync(run
    (await Deno.readTextFile("sketch/a.pl"))
    (`
        phrase(sentence(_, IR), "나비 가 꽃 을 보았다"),
        phrase(sentence(_, IR), En).
    `)
).then(x => console.log(x))
