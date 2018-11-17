import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.FROM_EMAIL,
    pass: process.env.FROM_PASSWORD
  }
});

export default async function sendEmail(to, assigned) {
  const { name: assignedName, suggestions, imagePath } = assigned;
  const message = `<p>Dear ${to.name},<p>` +
                  `<p>You have been assigned ${assignedName} for Secret Santa.<p>` +
                  `${suggestions
                    ? `<p>Here are some suggestions of what to get them:</p>` + 
                      `<ul>${suggestions.map(suggestion => `<li>${suggestion}</li>`).join('\n')}</ul>`
                    : ""}` +
                  `${imagePath
                    ? `<img src="cid:${assigned.imagePath}"/>`
                    : ""}`;

  const attachments = imagePath
    ? [{ path: `config/${imagePath}`, cid: imagePath }]
    : null;

  const options = {
    from: {
      name: 'Secret Santa',
      email: process.env.FROM_EMAIL
    },
    to: to.email,
    subject: `${to.name}'s Secret Santa`,
    html: message,
    attachments
  };

  await transporter.sendMail(options);
}