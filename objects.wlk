object stage0 {}

object tdGame {
    const stages = [stage0]
    method loadStage(stageNumber){
        stages.get(stageNumber).load()
    }
}
