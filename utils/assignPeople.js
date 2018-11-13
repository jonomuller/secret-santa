const MAX_RETRIES = 1000;

export default function assignPeople(people, conditions, count = 0) {
  const assignments = [];
  const shuffledPeople = shuffle(people);

  for (let i = 0; i < shuffledPeople.length; i++) {
    const sender = shuffledPeople[i];
    let receiver;

    if (i !== shuffledPeople.length - 1) {
      receiver = shuffledPeople[i+1];
    } else {
      receiver = shuffledPeople[0];      
    }

    assignments.push({ sender, receiver });
  }

  if (assignments.some(assignment => isInvalidAssignment(assignment.sender.name, assignment.receiver.name, conditions))) {
    if (count > MAX_RETRIES) {
      throw new Error();
    }

    const newCount = count += 1;
    console.log(`Conditions not met - retrying, count: ${newCount}`);
    return assignPeople(people, conditions, newCount);
  }

  return assignments;
}

const shuffle = arr => arr
  .map(a => [Math.random(), a])
  .sort((a, b) => a[0] - b[0])
  .map(a => a[1]);

function isInvalidAssignment(sender, receiver, conditions) {
  return sender === receiver
    || conditions[sender].includes(receiver)
    || conditions[receiver].includes(sender);
}
