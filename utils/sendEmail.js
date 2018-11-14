import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.FROM_EMAIL,
    pass: process.env.FROM_PASSWORD
  }
});

export default async function sendEmail(to, assigned) {
  const imageId = `${assigned.name}.png`;
  const message = `<p>Dear ${to.name},<p>` +
                  `<p>You have been assigned ${assigned.name} for Secret Santa.<p>` +
                  `${assigned.suggestions
                    ? `<p>Here are some suggestions of what to get them:</p>` + 
                      `<ul>${assigned.suggestions.map(suggestion => `<li>${suggestion}</li>`).join('\n')}</ul>`
                    : ""}` +
                  `<img src="${imageId}"/>`;

  const options = {
    from: {
      name: 'Secret Santa',
      email: 'rugen.secret.santa@gmail.com'
    },
    to: to.email,
    subject: `${to.name}'s Secret Santa`,
    html: message,
    attachments: [{
      path: `config/images/${imageId}`,
      cid: imageId
    }]
  };

  await transporter.sendMail(options);
}