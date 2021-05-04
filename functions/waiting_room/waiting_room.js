/* This is a viewer-request function that redirects new users to a waiting room */
/* while allowing a certain subset through to the origin, along with all returning users  */
/* Based on the example from https://aws.amazon.com/blogs/networking-and-content-delivery/visitor-prioritization-on-e-commerce-websites-with-cloudfront-and-lambdaedge/ */
/* When things break check out https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-testing-debugging.html */
/* Includes concepts from https://aws.amazon.com/blogs/networking-and-content-delivery/leveraging-external-data-in-lambdaedge/ */
/* ... and some tips from https://medium.com/@mnylen/lambda-edge-gotchas-and-tips-93083f8b4152 */
'use strict';

/*
 * The origin hit rate (a value between 0 and 1) specifies a percentage of 
 * users that go directly to the origin, while the rest go to
 * a "waiting room."
 */
const originHitRate = 0.3

const originAcceptingTraffic = true

exports.handler = (event, context, callback) => {
    let request = event.Records[0].cf.request;

    if (!allowToOrigin(request)) {
        request = redirectToWaitingRoom(request);
    }

    callback(null, request);
};

function allowToOrigin(request) {
    if (!originAcceptingTraffic) {
        console.log("Origin offline - All users go to the waiting room");
        return false;
    }
    if (isReturningUser(request.headers.cookie)) {
        console.log("A returning user goes to the origin.");
        return true;
    }
    if (Math.random() <= originHitRate) {
        console.log("A lucky user goes to the origin.");
        return true;
    }

    console.log("An unlucky user goes to the waiting room.");
    return false;
}

function isReturningUser(cookies) {
    /* 
     * Placeholder - Key off something else!
     */
    const cookieName = 'Voltage';
    const cookieValue = 'Noir';
    const parsedCookies = parseCookies(cookies);

    if (parsedCookies[cookieName] &&
        parsedCookies[cookieName] === cookieValue) {
        console.log(`Cookie "${cookieName}" has ` +
            `a valid secret value of "${cookieValue}".`);
        return true;
    }

    return false;
}

function redirectToWaitingRoom(request) {
    const waitingRoomPath = '/waiting_room/index.html'

    const redirectResponse = {
        status: '302',
        statusDescription: 'Found',
        headers: {
            'location': [{
                key: 'Location',
                value: waitingRoomPath,
            }],
            'cache-control': [{
                key: 'Cache-Control',
                value: "private"
            }],
        },
    };

    return redirectResponse
}

function parseCookies(cookies) {
    cookies = cookies || [];
    let parsed = {};
    for (let hdr of cookies) {
        for (let cookie of hdr.value.split(';')) {
            const kv = cookie.split('=');
            if (kv[0] && kv[1]) {
                parsed[kv[0].trim()] = kv[1].trim();
            }
        }
    }
    return parsed;
}
