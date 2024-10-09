import { Badge } from "@/components/ui/badge"
import { Card } from "@/components/ui/card"
import { Github, Linkedin, Mail } from "lucide-react"

export default function Component() {
  return (
    <div className="max-w-4xl mx-auto p-6 bg-white dark:bg-gray-900 text-gray-800 dark:text-gray-200">
      <div className="text-center mb-8">
        <h1 className="text-4xl font-bold mb-4">Kadir Goksal</h1>
        <p className="text-xl text-gray-600 dark:text-gray-400">DevOps Engineer</p>
      </div>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-4">👨‍💻 About Me</h2>
        <p className="mb-4">
          With over 2 years of IT experience, including more than 1 year in DevOps, I'm passionate about automating IT operations and staying updated with emerging technologies. My expertise includes:
        </p>
        <ul className="list-disc list-inside mb-4">
          <li>Implementing and managing CI/CD pipelines (Jenkins)</li>
          <li>Containerization and orchestration</li>
          <li>Monitoring and automating production infrastructure</li>
          <li>Building tools to minimize errors</li>
          <li>Conducting root cause analysis</li>
          <li>Enhancing customer experience</li>
        </ul>
        <p>
          Currently, I'm working as a DevOps Engineer at Nimbous, where I contribute to optimizing cloud infrastructure and automating workflows.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-4">🏆 Certifications</h2>
        <ul className="list-disc list-inside">
          <li>HashiCorp Terraform Associate</li>
          <li>Azure Fundamentals</li>
          <li>Certified Kubernetes Administrator (CKA)</li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-4">🛠 Skills & Technologies</h2>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <h3 className="text-lg font-semibold mb-2">Languages</h3>
            <p>Python, JavaScript, TypeScript, Bash, HTML, CSS</p>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-2">DevOps</h3>
            <p>Jenkins, Docker, Kubernetes, Ansible, Terraform, Maven</p>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-2">Cloud</h3>
            <p>AWS (EC2, ECS, ECR, DynamoDB, S3, RDS, ALB, VPC, EKS), Azure (VM, Load Balancer, AKS, SQL)</p>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-2">Monitoring</h3>
            <p>Grafana, Prometheus</p>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-2">Databases</h3>
            <p>SQL (PostgreSQL, MySQL), NoSQL (MongoDB, DynamoDB)</p>
          </div>
          <div>
            <h3 className="text-lg font-semibold mb-2">Other</h3>
            <p>Jira, Git, Linux</p>
          </div>
        </div>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-4">🌟 Professional Highlights</h2>
        <ul className="list-disc list-inside">
          <li>Proficient in infrastructure as code using Terraform</li>
          <li>Experience with Jira for agile project management</li>
          <li>Strong communication, adaptability, and teamwork skills</li>
          <li>Focus on innovative solutions and rigorous testing practices</li>
          <li>Background in using automation tools for software updates across cloud platforms (AWS, Azure)</li>
          <li>Expertise in optimizing cloud resources and managing costs</li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-4">📊 GitHub Stats</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Card className="p-4">
            <h3 className="text-lg font-semibold mb-2">GitHub Activity</h3>
            <img src="https://github-readme-stats.vercel.app/api?username=KGoksal&show_icons=true&theme=radical" alt="KGoksal's GitHub Stats" className="w-full" />
          </Card>
          <Card className="p-4">
            <h3 className="text-lg font-semibold mb-2">Streak Stats</h3>
            <img src="https://github-readme-streak-stats.herokuapp.com/?user=KGoksal&theme=radical" alt="KGoksal's GitHub Streak" className="w-full" />
          </Card>
        </div>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-4">🔧 Technologies & Tools</h2>
        <div className="flex flex-wrap gap-2">
          <Badge variant="secondary">Linux</Badge>
          <Badge variant="secondary">VSCode</Badge>
          <Badge variant="secondary">Python</Badge>
          <Badge variant="secondary">JavaScript</Badge>
          <Badge variant="secondary">Bash</Badge>
          <Badge variant="secondary">Docker</Badge>
          <Badge variant="secondary">Kubernetes</Badge>
          <Badge variant="secondary">Terraform</Badge>
          <Badge variant="secondary">AWS</Badge>
          <Badge variant="secondary">Azure</Badge>
        </div>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-4">📫 Get in Touch</h2>
        <div className="flex justify-center space-x-4">
          <a href="https://www.linkedin.com/in/kgoksal/" className="text-blue-500 hover:text-blue-600">
            <Linkedin className="w-8 h-8" />
          </a>
          <a href="https://github.com/KGoksal" className="text-gray-700 hover:text-gray-900 dark:text-gray-300 dark:hover:text-gray-100">
            <Github className="w-8 h-8" />
          </a>
          <a href="mailto:abdulkadirgoksal@gmail.com" className="text-red-500 hover:text-red-600">
            <Mail className="w-8 h-8" />
          </a>
        </div>
      </section>

      <div className="text-center mt-8">
        <img src="https://user-images.githubusercontent.com/74038190/212741999-016fddbd-617a-4448-8042-0ecf907aea25.gif" alt="DevOps Animation" className="w-full max-w-2xl mx-auto" />
      </div>
    </div>
  )
}
