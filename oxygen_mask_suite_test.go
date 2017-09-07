package oxygen_mask_test

import (
	"os/exec"
	"strings"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gexec"

	"testing"
)

var (
	flyBin    string
	flyTarget string
)

func TestOxygenMask(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "OxygenMask Suite")
}

func which(name string) bool {
	cmd := exec.Command("which", name)

	session, err := gexec.Start(cmd, GinkgoWriter, GinkgoWriter)
	Expect(err).To(Succeed())

	<-session.Exited
	return session.ExitCode() == 0
}

func emitDatadogMetric(name string, value int) {
	//TODO
}

func fly(argv ...string) {
	wait(spawnFly(argv...))
}

func wait(session *gexec.Session) {
	<-session.Exited
	Expect(session.ExitCode()).To(Equal(0))
}

func spawnFly(argv ...string) *gexec.Session {
	return spawn(flyBin, append([]string{"-t", flyTarget}, argv...)...)
}

func spawn(argc string, argv ...string) *gexec.Session {
	By("running: " + argc + " " + strings.Join(argv, " "))
	cmd := exec.Command(argc, argv...)
	session, err := gexec.Start(cmd, GinkgoWriter, GinkgoWriter)
	Expect(err).ToNot(HaveOccurred())
	return session
}
