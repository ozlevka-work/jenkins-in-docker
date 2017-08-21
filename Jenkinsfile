@Library('main-shared-library')
import com.ericom.jenkins.PipeLine

def pl = new PipeLine(steps, currentBuild)
def lib = libraryResource "com/ericom/defenition/component-defenition.yml"
pl.loadConfig(lib)
node {
    //pl.run()
    pl.runTestOnly()
}