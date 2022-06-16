import * as functions from "firebase-functions";

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const PromisePool = require('es6-promise-pool').default;
const MAX_CONCURRENT = 3;

exports.accountcleanup = functions.pubsub.schedule('every day 00:00').onRun(async context => {

    const inactiveUsers = await getInactiveUsers();

    const promisePool = new PromisePool(() => deleteInactiveUser(inactiveUsers), MAX_CONCURRENT);
    await promisePool.start();
    functions.logger.log('User cleanup finished');
});

function deleteInactiveUser(inactiveUsers) {
    if (inactiveUsers.length > 0) {
        const userToDelete = inactiveUsers.pop();

        return admin.auth().deleteUser(userToDelete.uid).then(() => {
            return functions.logger.log(
                'Deleted user account',
                userToDelete.uid,
                'because of inactivity'
            );
        }).catch((error) => {
            return functions.logger.error(
                'Deletion of inactive user account',
                userToDelete.uid,
                'failed:',
                error
            );
        });
    } else {
        return null;
    }
}

async function getInactiveUsers(users = [], nextPageToken) {
    const result = await admin.auth().listUsers(1000, nextPageToken);

    const inactiveUsers = result.users.filter(
        user => Date.parse(user.metadata.lastRefreshTime || user.metadata.lastSignInTime) < (Date.now() - 30 * 24 * 60 * 60 * 1000));

    users = users.concat(inactiveUsers);

    if (result.pageToken) {
        return getInactiveUsers(users, result.pageToken);
    }

    return users;
}