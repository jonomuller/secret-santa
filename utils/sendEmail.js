import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.FROM_EMAIL,
    pass: process.env.FROM_PASSWORD
  }
});

export default async function sendEmail(to, assigned) {
  const message = `Dear ${to.name},\n\n` +
                  `You have been assigned ${assigned.name} for Secret Santa.\n\n` +
                  `${assigned.suggestions
                    ? `Here are some suggestions of what to get them:\n` + 
                      `${assigned.suggestions.map(suggestion => `– ${suggestion}`).join('\n')}`
                    : ""}`;

  const options = {
    from: {
      name: 'Secret Santa',
      email: 'rugen.secret.santa@gmail.com'
    },
    to: to.email,
    subject: `${to.name}'s Secret Santa`,
    text: message
  };

  await transporter.sendMail(options);
}