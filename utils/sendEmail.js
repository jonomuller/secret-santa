import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.FROM_EMAIL,
    pass: process.env.FROM_PASSWORD
  }
});

export default async function sendEmail(from, to) {
  const options = {
    from: 'Secret Santa',
    to: to.email,
    subject: `${to.name}'s Secret Santa`,
    html: `<p>Hello!</p>`
  };

  await transporter.sendMail(options);
}