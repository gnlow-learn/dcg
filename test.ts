import { use, run } from "./src/run.ts"

use("romanize.pl")

await Array.fromAsync(run
    (await Deno.readTextFile("sketch/main.pl"))
    (`
        romanize("멜트", Res).
    `)
).then(x => {
    console.log(
        x.map(answer =>
            answer.status == "success"
                ? answer.answer.Res: "<failure>"
        )
    )
})
