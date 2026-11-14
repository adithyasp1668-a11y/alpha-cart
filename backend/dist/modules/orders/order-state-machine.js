"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.canTransitionOrder = canTransitionOrder;
const VALID_TRANSITIONS = {
    PENDING_PAYMENT: ['PLACED', 'CANCELLED'],
    PLACED: ['CONFIRMED', 'CANCELLED'],
    CONFIRMED: ['ACCEPTED_BY_SELLER', 'CANCELLED'],
    ACCEPTED_BY_SELLER: ['PREPARING', 'CANCELLED'],
    PREPARING: ['READY_FOR_PICKUP', 'CANCELLED'],
    READY_FOR_PICKUP: ['DELIVERY_PARTNER_ASSIGNED', 'CANCELLED'],
    DELIVERY_PARTNER_ASSIGNED: ['PICKED_UP', 'CANCELLED'],
    PICKED_UP: ['ON_THE_WAY'],
    ON_THE_WAY: ['DELIVERED'],
    DELIVERED: [],
    CANCELLED: ['REFUNDED'],
    REFUNDED: [],
};
function canTransitionOrder(from, to) {
    const allowed = VALID_TRANSITIONS[from];
    return allowed ? allowed.includes(to) : false;
}
