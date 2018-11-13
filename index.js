import config from './config/config.json';
import assignPeople from "./utils/assignPeople";
import sendEmail from "./utils/sendEmail";

async function assignAndSendEmails() {
  const assignments = assignPeople(config.people, config.conditions);
  await Promise.all(
    assignments.map(assignment => 
      sendEmail(assignment.sender, assignment.receiver)
    )
  );
}

assignAndSendEmails();